# OpenCost on Kubernetes

> **Description:** Open Source cost monitoring and allocation for Kubernetes.
> **Version:** 1.108.0 (Example)

---

## 🏗️ Architecture

- **OpenCost UI:** Dashboard for visualizing cost data.
- **Cost Model:** Calculates costs based on resource usage and pricing.
- **Prometheus:** Stores metrics (OpenCost scrapes Prometheus or pushes to it).

---

## 📋 Prerequisites

- Kubernetes Cluster 1.23+
- Helm 3+
- Prometheus (e.g., Kube-Prometheus-Stack) installed and accessible.

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add opencost https://opencost.github.io/opencost-helm-chart
helm repo update
```

### 2. Install OpenCost
```bash
helm upgrade --install opencost opencost/opencost \
  --namespace opencost \
  --create-namespace \
  --values values.yaml \
  --version 1.29.0
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `opencost.prometheus.external.url` | `http://prometheus-operated.monitoring:9090` | URL of existing Prometheus. |
| `opencost.exporter.enabled` | `true` | Expose cost metrics for Prometheus to scrape. |
| `opencost.ui.enabled` | `true` | Enable the UI. |
| `service.type` | `ClusterIP` | Service type (use LoadBalancer/Ingress for external access). |

---

## 💻 Usage

### Access UI
Forward the port to access the dashboard:
```bash
kubectl port-forward svc/opencost 9090:9090 -n opencost
```
Open `http://localhost:9090` in your browser.

### View Cost Allocation
- **By Namespace:** See which namespaces are spending the most.
- **By Deployment:** Drill down into specific workloads.
- **By Label:** Use labels like `app` or `team` for cost attribution.

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n opencost
```

### 2. Check Logs
```bash
kubectl logs -f deployment/opencost -n opencost
```
*Look for successful connection to Prometheus.*

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade opencost opencost/opencost -n opencost --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall opencost -n opencost
```
