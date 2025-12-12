# Kube-Prometheus-Stack on Kubernetes

> **Description:** A collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.
> **Chart:** `prometheus-community/kube-prometheus-stack`
> **Documentation:** [MONITORING_CRDS.md](../MONITORING_CRDS.md) - Deep dive into ServiceMonitor, PodMonitor, and PrometheusRule.

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
  --version 80.2.0
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

---

## ❓ Troubleshooting

### Node Exporter not starting (PodSecurity Issue)
If `node-exporter` pods are failing to start with `violates PodSecurity "restricted:latest"`, it means the namespace has a restricted policy preventing privileged pods.

**Fix:** Label the namespace to allow privileged pods.
```bash
kubectl label --overwrite ns monitoring pod-security.kubernetes.io/enforce=privileged
kubectl label --overwrite ns monitoring pod-security.kubernetes.io/audit=privileged
kubectl label --overwrite ns monitoring pod-security.kubernetes.io/warn=privileged
```

---

### Node Exporter Connection Timeout
If Prometheus shows `context deadline exceeded` or `Connection timed out` for `node-exporter` targets (port 9100), the Host Firewall is likely checking the connection.

**Fix:** Disable `hostNetwork` to use the Pod Overlay Network.
1. Update `values.yaml`:
   ```yaml
   nodeExporter:
     hostNetwork: false
     service:
       port: 9100
       targetPort: 9100
   ```
2. **Force Update DaemonSet:** Helm might not apply `hostNetwork` changes to existing DaemonSets.
   ```bash
   kubectl delete ds kube-prometheus-stack-prometheus-node-exporter -n monitoring
   helm upgrade --install ...
   # OR
   kubectl patch ds kube-prometheus-stack-prometheus-node-exporter -n monitoring --patch '{"spec": {"template": {"spec": {"hostNetwork": false, "hostPID": false}}}}'
   ```

---

## 🧹 Cleanup

```bash
helm uninstall kube-prometheus-stack -n monitoring
# Delete CRDs
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheusagents.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd scrapeconfigs.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.comv
```
