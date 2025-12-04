# Kyverno on Kubernetes

> **Description:** Kubernetes Native Policy Management.
> **Version:** 1.10.0 (Example)

---

## 🏗️ Architecture

- **Admission Controller:** Validates, mutates, and generates resources.
- **Policy Reporter:** (Optional) UI for viewing policy violations.
- **Background Controller:** Scans existing resources.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.23+
- Helm 3+

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
```

### 2. Install Kyverno
```bash
helm upgrade --install kyverno kyverno/kyverno \
  --namespace kyverno \
  --create-namespace \
  --values values.yaml \
  --version 3.0.0
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `replicaCount` | `3` | High Availability. |
| `admissionController.replicas` | `3` | HA for admission webhooks. |
| `backgroundController.replicas` | `1` | Background scanning. |
| `cleanupController.replicas` | `1` | Cleanup jobs. |

---

## 💻 Usage

### Create a Policy
Example: Require `app` label on all Pods.

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-labels
spec:
  validationFailureAction: Enforce
  rules:
  - name: check-for-labels
    match:
      any:
      - resources:
          kinds:
          - Pod
    validate:
      message: "label 'app' is required"
      pattern:
        metadata:
          labels:
            app: "?*"
```

Apply it:
```bash
kubectl apply -f policy.yaml
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n kyverno
```

### 2. Test Policy
Try to create a pod without the label:
```bash
kubectl run test-pod --image=nginx
# Should fail with: "label 'app' is required"
```

Try with label:
```bash
kubectl run test-pod --image=nginx --labels=app=test
# Should succeed
```

---

## 🧹 Maintenance

### Uninstall
```bash
helm uninstall kyverno -n kyverno
```
