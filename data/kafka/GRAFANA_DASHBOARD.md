# 📊 Adding Kafka Dashboard to Grafana

This guide explains how to monitor your Strimzi Kafka cluster using Grafana. We will cover enabling metrics in Kafka, ensuring Prometheus is scraping them, and importing dashboards into Grafana.

## 📋 Prerequisites

- [ ] **Kubernetes Cluster** with Strimzi Operator installed.
- [ ] **Prometheus** installed (e.g., `kube-prometheus-stack`) and configured to scrape Strimzi metrics.
- [ ] **Grafana** installed.

---

## ⚙️ 1. Enable Metrics in Kafka

Ensure your `Kafka` Custom Resource has `metricsConfig` enabled. This exposes JMX metrics to an endpoint that Prometheus can scrape.

**Example `kafka.yaml` snippet:**

```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: my-cluster
spec:
  kafka:
    # ... other settings ...
    metricsConfig:
      type: jmxPrometheusExporter
      valueFrom:
        configMapKeyRef:
          name: kafka-metrics
          key: kafka-metrics-config.yml
  zookeeper:
    # ... other settings ...
    metricsConfig:
      type: jmxPrometheusExporter
      valueFrom:
        configMapKeyRef:
          name: kafka-metrics
          key: zookeeper-metrics-config.yml
    # ...
```

> **Note:** The ConfigMap `kafka-metrics` typically comes with Strimzi examples or can be created manually. See [Strimzi Metrics Examples](https://github.com/strimzi/strimzi-kafka-operator/tree/latest/examples/metrics).

---

## 🔍 2. Configure Prometheus Scraping

If you are using `kube-prometheus-stack` (Prometheus Operator), you need a `PodMonitor` to tell Prometheus to scrape the Kafka pods.

**Create `pod-monitor.yaml`:**

Don't forget to add release label to the pod-monitor.yaml if you are using `kube-prometheus-stack`.

Apply it to the **Prometheus namespace** (e.g., `monitoring`). This ensures Prometheus can find the `PodMonitor` resource, and the `namespaceSelector` within it tells Prometheus to look for pods in the `kafka` namespace.

```bash
kubectl apply -f pod-monitor.yaml -n monitoring
```

For more information, see the [kube-prometheus-stack documentation](https://github.com/prometheus-operator/kube-prometheus-stack) and [Strimzi Metrics Examples](https://github.com/strimzi/strimzi-kafka-operator/tree/0.49.1/examples/metrics).

> **Note:** You can also deploy it in the `kafka` namespace if your Prometheus is configured to select PodMonitors from all namespaces (check `podMonitorNamespaceSelector` in your Prometheus CR).

---

## 📈 3. Import Dashboard to Grafana

There are several popular dashboards for Strimzi Kafka. One of the most reliable is the **Strimzi Kafka Exporter** dashboard.

### Method 1: UI Import (Quickest)

1. Open Grafana in your browser.
2. Go to **Dashboards** > **New** > **Import**.
3. Enter one of the following Dashboard IDs:
    - **721**: Strimzi Kafka Exporter (Requires Kafka Exporter component to be enabled in Strimzi).
    - **11520**: Strimzi Zookeeper.
    - **11962**: Strimzi Kafka.
4. Click **Load**.
5. Select your Prometheus data source.
6. Click **Import**.

### Method 2: GitOps (ConfigMap)

For production, it's best to manage dashboards as code using a ConfigMap with a specific label that the Grafana sidecar watches.

**`kafka-dashboard.yaml`**:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: kafka-dashboard
  namespace: monitoring # Namespace where Grafana is running
  labels:
    grafana_dashboard: "1" # Label that triggers the sidecar to mount this
data:
  kafka-dashboard.json: |
    {
      "annotations": {
        "list": [
          {
            "builtIn": 1,
            "datasource": {
              "type": "grafana",
              "uid": "-- Grafana --"
            },
            "enable": true,
            "hide": true,
            "iconColor": "rgba(0, 211, 255, 1)",
            "name": "Annotations & Alerts",
            "target": {
              "limit": 100,
              "matchAny": false,
              "tags": [],
              "type": "dashboard"
            },
            "type": "dashboard"
          }
        ]
      },
      ... (Full JSON content of the dashboard) ...
    }
```

> **Tip:** You can download the JSON from the [Grafana Dashboard page](https://grafana.com/grafana/dashboards/721-strimzi-kafka-exporter/) and paste it into the ConfigMap.

### Method 3: Helm Values (kube-prometheus-stack)

If using the `kube-prometheus-stack` Helm chart, you can add the dashboard URL directly in `values.yaml`:

```yaml
grafana:
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'default'
        orgId: 1
        folder: ''
        type: file
        disableDeletion: false
        editable: true
        options:
          path: /var/lib/grafana/dashboards/default
  dashboards:
    default:
      kafka-exporter:
        gnetId: 721
        revision: 1
        datasource: Prometheus
```

---

## ✅ Verification

### 1. Check Prometheus Targets

Before checking Grafana, ensure Prometheus is scraping the metrics.

1. Port-forward the Prometheus service:
   ```bash
   # Adjust the service name/namespace as needed
   kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090 -n monitoring
   ```
2. Open [http://localhost:9090/targets](http://localhost:9090/targets).
3. Look for a target named `cluster-operator-metrics` (or similar).
   - **State UP**: Scraping is working.
   - **State DOWN**: Network issue (check Security Groups or Network Policies).
   - **Target Missing**: Label mismatch on `PodMonitor`.

### 2. Check Grafana Dashboard

1. Go to your Grafana instance.
2. Navigate to the newly imported **Strimzi Kafka Exporter** dashboard.
3. Verify that panels are populating with data.

