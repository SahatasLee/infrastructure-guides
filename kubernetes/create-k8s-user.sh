#!/bin/bash

# รับ input จากผู้ใช้
read -p "Enter Service Account Name: " SERVICE_ACCOUNT_NAME
read -p "Enter Service Account Namespace: " SA_NAMESPACE

# รับ namespaces (comma-separated)
read -p "Enter Namespaces (comma-separated, e.g., argocd,gitlab): " NS_INPUT
IFS=',' read -ra NAMESPACES <<< "$NS_INPUT"

# ตัดช่องว่างออก (ถ้ามี)
for i in "${!NAMESPACES[@]}"; do
  NAMESPACES[$i]=$(echo "${NAMESPACES[$i]}" | xargs)
done

read -p "Enter Kubeconfig File Name (default: ${SERVICE_ACCOUNT_NAME}-kubeconfig.yaml): " KUBECONFIG_FILE
KUBECONFIG_FILE=${KUBECONFIG_FILE:-"${SERVICE_ACCOUNT_NAME}-kubeconfig.yaml"}

SECRET_NAME="${SERVICE_ACCOUNT_NAME}-token"

# แสดงข้อมูลที่กรอก
echo ""
echo "=== Configuration Summary ==="
echo "Service Account Name: $SERVICE_ACCOUNT_NAME"
echo "Service Account Namespace: $SA_NAMESPACE"
echo "Target Namespaces: ${NAMESPACES[*]}"
echo "Kubeconfig File: $KUBECONFIG_FILE"
echo "============================"
echo ""
read -p "Continue with this configuration? (y/n): " CONFIRM

if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 1
fi

echo ""

# สร้าง ServiceAccount
kubectl create serviceaccount $SERVICE_ACCOUNT_NAME -n $SA_NAMESPACE

# สร้าง Secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: $SECRET_NAME
  namespace: $SA_NAMESPACE
  annotations:
    kubernetes.io/service-account.name: $SERVICE_ACCOUNT_NAME
type: kubernetes.io/service-account-token
EOF

# สร้าง Role และ RoleBinding สำหรับแต่ละ namespace
for NS in "${NAMESPACES[@]}"; do
  kubectl create namespace $NS --dry-run=client -o yaml | kubectl apply -f -

  cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${SERVICE_ACCOUNT_NAME}-rolebinding
  namespace: $NS
subjects:
- kind: ServiceAccount
  name: $SERVICE_ACCOUNT_NAME
  namespace: $SA_NAMESPACE
roleRef:
  kind: ClusterRole
  name: admin
  apiGroup: rbac.authorization.k8s.io
EOF
done

# รอให้ secret พร้อม
sleep 3

# Generate kubeconfig
CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
CLUSTER_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
TOKEN=$(kubectl get secret $SECRET_NAME -n $SA_NAMESPACE -o jsonpath='{.data.token}' | base64 -d)
CA_CERT=$(kubectl get secret $SECRET_NAME -n $SA_NAMESPACE -o jsonpath='{.data.ca\.crt}')

cat > $KUBECONFIG_FILE <<EOF
apiVersion: v1
kind: Config
clusters:
- name: ${CLUSTER_NAME}
  cluster:
    certificate-authority-data: ${CA_CERT}
    server: ${CLUSTER_SERVER}
contexts:
- name: ${SERVICE_ACCOUNT_NAME}@${CLUSTER_NAME}
  context:
    cluster: ${CLUSTER_NAME}
    namespace: ${NAMESPACES[0]}
    user: ${SERVICE_ACCOUNT_NAME}
current-context: ${SERVICE_ACCOUNT_NAME}@${CLUSTER_NAME}
users:
- name: ${SERVICE_ACCOUNT_NAME}
  user:
    token: ${TOKEN}
EOF

echo "✓ Kubeconfig created: $KUBECONFIG_FILE"
echo "✓ Allowed namespaces: ${NAMESPACES[*]}"
echo ""
echo "Test with: export KUBECONFIG=$KUBECONFIG_FILE"

# สร้างไฟล์สรุป output
OUTPUT_SUMMARY_FILE="${SERVICE_ACCOUNT_NAME}-resources-summary.txt"
cat > $OUTPUT_SUMMARY_FILE <<EOF
=======================================================
Kubernetes Resources Summary
Created at: $(date)
=======================================================

1. Service Account
   - Name: $SERVICE_ACCOUNT_NAME
   - Namespace: $SA_NAMESPACE
   - Command to verify:
     kubectl get sa $SERVICE_ACCOUNT_NAME -n $SA_NAMESPACE

2. Secret (Token)
   - Name: $SECRET_NAME
   - Namespace: $SA_NAMESPACE
   - Type: kubernetes.io/service-account-token
   - Command to verify:
     kubectl get secret $SECRET_NAME -n $SA_NAMESPACE

3. RoleBindings (Admin access per namespace)
EOF

# เพิ่มรายละเอียด RoleBinding แต่ละ namespace
for NS in "${NAMESPACES[@]}"; do
  cat >> $OUTPUT_SUMMARY_FILE <<EOF
   - Namespace: $NS
     RoleBinding Name: ${SERVICE_ACCOUNT_NAME}-rolebinding
     Role: ClusterRole/admin
     Command to verify:
       kubectl get rolebinding ${SERVICE_ACCOUNT_NAME}-rolebinding -n $NS

EOF
done

cat >> $OUTPUT_SUMMARY_FILE <<EOF
4. Kubeconfig File
   - File: $KUBECONFIG_FILE
   - Cluster: $CLUSTER_NAME
   - Server: $CLUSTER_SERVER
   - Context: ${SERVICE_ACCOUNT_NAME}@${CLUSTER_NAME}
   - Default Namespace: ${NAMESPACES[0]}

5. Namespaces with Admin Access
   ${NAMESPACES[*]}

=======================================================
Quick Test Commands:
=======================================================
export KUBECONFIG=$KUBECONFIG_FILE
kubectl get pods -n ${NAMESPACES[0]}
kubectl auth can-i create pods -n ${NAMESPACES[0]}

=======================================================
Cleanup Commands (if needed):
=======================================================
kubectl delete sa $SERVICE_ACCOUNT_NAME -n $SA_NAMESPACE
kubectl delete secret $SECRET_NAME -n $SA_NAMESPACE
EOF

for NS in "${NAMESPACES[@]}"; do
  echo "kubectl delete rolebinding ${SERVICE_ACCOUNT_NAME}-rolebinding -n $NS" >> $OUTPUT_SUMMARY_FILE
done

echo "rm $KUBECONFIG_FILE" >> $OUTPUT_SUMMARY_FILE

echo ""
echo "✓ Summary file created: $OUTPUT_SUMMARY_FILE"