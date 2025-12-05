# Kube-Prometheus-Stack on Kubernetes

> **Description:** A collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.
> **Chart:** `prometheus-community/kube-prometheus-stack`

---

## 🏗️ Architecture

- **Prometheus Operator:** Manages Prometheus and Alertmanager clusters.
- **Prometheus:** Collects metrics from configured targets.
- **Alertmanager:** Handles alerts sent by client applications such as the Prometheus server.
- **Grafana:** Visualizes metrics.
- **Node Exporter:** Exports hardware and OS metrics exposed by *NIX kernels.
- **Kube State Metrics:** Listens to the Kubernetes API server and generates metrics about the state of the objects.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.19+
- Helm 3+

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 2. Install Kube-Prometheus-Stack
```bash
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --values values.yaml \
  --version 56.0.0
```

---

## ⚙️ Configuration

The `values.yaml` file configures the stack. Key areas include:

- **Grafana:** Admin password, Ingress, and Persistence.
- **Prometheus:** Retention period, Storage Class, and Resources.
- **Alertmanager:** Receivers (Slack, Email, PagerDuty) and Routes.

### Accessing Dashboards
If Ingress is enabled (in `values.yaml`), access Grafana at your configured host (e.g., `grafana.example.com`).

Otherwise, use port-forwarding:
```bash
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring
```
Open [http://localhost:3000](http://localhost:3000). Default login: `admin` / `prom-operator` (or what you set in values).

---

## 💻 Usage

### Adding ServiceMonitors
To monitor an application, create a `ServiceMonitor` CRD.

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-app
  labels:
    release: kube-prometheus-stack
spec:
  selector:
    matchLabels:
      app: my-app
  endpoints:
  - port: web
```

---

## 🧹 Cleanup

```bash
helm uninstall kube-prometheus-stack -n monitoring
```
