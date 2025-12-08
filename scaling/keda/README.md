# KEDA (Kubernetes Event-driven Autoscaling)

> **Description:** KEDA allows for fine-grained autoscaling (including to/from zero) for event-driven Kubernetes workloads. KEDA serves as a Kubernetes Metrics Server and allows you to define autoscaling rules using a custom resource called `ScaledObject`.
> **Version:** 2.16.1 (Example)

---

## 🏗️ Architecture

- **KEDA Operator:** Activates and deactivates deployments (scales to/from zero).
- **Metrics Server:** Exposes event data (e.g., queue length) to the Horizontal Pod Autoscaler (HPA) to drive scaling.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.23+
- Helm 3+

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
```

### 2. Install KEDA
```bash
helm upgrade --install keda kedacore/keda \
  --namespace keda \
  --create-namespace \
  --values values.yaml \
  --version 2.16.1
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `operator.replicaCount` | `1` | Number of operator replicas. |
| `metricsServer.replicaCount` | `1` | Number of metrics server replicas. |
| `resources` | _varies_ | Resource requests and limits. |

---

## 💻 Usage

### 1. Define a ScaledObject
See [example-scaledobject.yaml](example-scaledobject.yaml) for a Cron-based scaler.

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: cron-scaled-object
  namespace: default
spec:
  scaleTargetRef:
    name: my-deployment
  triggers:
  - type: cron
    metadata:
      timezone: Asia/Bangkok
      start: 0 0 * * *
      end: 1 0 * * *
      desiredReplicas: "5"
```

Apply it:
```bash
kubectl apply -f example-scaledobject.yaml
```

### 2. Verification
Check the status of the ScaledObject:
```bash
kubectl get scaledobject
kubectl describe scaledobject cron-scaled-object
```

Check the generated HPA:
```bash
kubectl get hpa
```

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade keda kedacore/keda -n keda --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall keda -n keda
```
