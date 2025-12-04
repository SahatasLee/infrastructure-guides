# Karmada on Kubernetes

> **Description:** Kubernetes Armada - Multi-Cluster Management.
> **Version:** 1.8.0 (Example)

---

## 🏗️ Architecture

- **Karmada Control Plane:** The central management point (API Server, Controller Manager, Scheduler).
- **Member Clusters:** The clusters managed by Karmada.
- **Karmada Agent:** (Optional) Runs in member clusters for Pull mode.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.23+ (Host Cluster)
- `karmadactl` CLI installed (Recommended) or Helm 3+
- At least one Member Cluster to join.

---

## 🚀 Installation

### Option 1: Using `karmadactl` (Recommended)

1. **Install CLI:**
   ```bash
   curl -s https://raw.githubusercontent.com/karmada-io/karmada/master/hack/install-cli.sh | sudo bash
   ```

2. **Install Karmada:**
   ```bash
   karmadactl init
   ```

### Option 2: Using Helm

1. **Add Repo:**
   ```bash
   helm repo add karmada-charts https://raw.githubusercontent.com/karmada-io/karmada/master/charts
   helm repo update
   ```

2. **Install:**
   ```bash
   helm install karmada karmada-charts/karmada -n karmada-system --create-namespace --version 1.8.0
   ```

---

## ⚙️ Configuration

### Join a Cluster (Push Mode)
Assuming you have the kubeconfig for the member cluster:

```bash
karmadactl join member1 --cluster-kubeconfig=$HOME/.kube/config --cluster-context=member1-context
```

### Check Cluster Status
```bash
kubectl get clusters
```

---

## 💻 Usage

### 1. Create a Propagation Policy
Define how resources should be distributed.

```yaml
apiVersion: policy.karmada.io/v1alpha1
kind: PropagationPolicy
metadata:
  name: nginx-propagation
spec:
  resourceSelectors:
    - apiVersion: apps/v1
      kind: Deployment
      name: nginx
  placement:
    clusterAffinity:
      clusterNames:
        - member1
```

### 2. Deploy Resource
Apply the Deployment to the Karmada Control Plane:

```bash
kubectl apply -f nginx-deployment.yaml
kubectl apply -f propagation-policy.yaml
```

### 3. Verify Distribution
Check if the pod is running on the member cluster:

```bash
karmadactl get pods
```

---

## ✅ Verification

### 1. Check Control Plane Pods
```bash
kubectl get pods -n karmada-system
```

### 2. Check Member Clusters
```bash
kubectl get clusters
# Should show 'Ready'
```

---

## 🧹 Maintenance

### Unjoin Cluster
```bash
karmadactl unjoin member1
```

### Uninstall
```bash
karmadactl deinit
```
