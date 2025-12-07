# 👁️ Monitoring CRDs (`monitoring.coreos.com/v1`)

The **Prometheus Operator** introduces specific Custom Resource Definitions (CRDs) to simplify the configuration of Prometheus, Alertmanager, and related components. Instead of managing a large, static `prometheus.yaml` configuration file, you define these resources in Kubernetes, and the Operator automatically generates the configuration.

## 🔑 Key Resources

### 1. `ServiceMonitor`
**Use case:** You have a Kubernetes `Service` pointing to your pods, and you want Prometheus to scrape the endpoints defined by that Service.

 **Example:**
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-app-monitor
  labels:
    release: kube-prometheus-stack  # CRITICAL: Must match Prometheus Rule Selector
spec:
  selector:
    matchLabels:
      app: my-app  # Matches labels on your Service
  endpoints:
  - port: web      # Name of the port in the Service
    path: /metrics
    interval: 30s
```

### 2. `PodMonitor`
**Use case:** You want to scrape Pods directly *without* a Service (or bypassing the Service). Common for scraping sidecars (e.g., Envoy) or jobs that don't need a Service.

**Example:**
```yaml
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: sidecar-monitor
  labels:
    release: kube-prometheus-stack
spec:
  selector:
    matchLabels:
      app: my-app  # Matches labels on the Pod itself
  podMetricsEndpoints:
  - port: metrics  # Name of the port in the Pod
    path: /metrics
```

### 3. `PrometheusRule`
**Use case:** Defining alerting rules and recording rules.

**Example:**
```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: my-app-alerts
  labels:
    release: kube-prometheus-stack
spec:
  groups:
  - name: my-app.rules
    rules:
    - alert: HighErrorRate
      expr: job:request_error_rate:rate5m{job="my-app"} > 1
      for: 5m
      labels:
        severity: critical
      annotations:
        summary: High error rate on {{ $labels.instance }}
```

---

## 🔍 How Prometheus Finds Your Monitors

This is the **#1 source of confusion**. Just creating a `ServiceMonitor` isn't enough; Prometheus must "select" it.

The Prometheus CR (Custom Resource) has fields like `serviceMonitorSelector`, `podMonitorSelector`, and `ruleSelector`. These define which CRDs Prometheus will pick up.

**Check your Prometheus configuration:**
```bash
kubectl get prometheus -n monitoring -o yaml
```

Look for:
```yaml
spec:
  serviceMonitorSelector:
    matchLabels:
      release: kube-prometheus-stack  # <--- This is the key!
```

If your Prometheus requires `release: kube-prometheus-stack`, then **ALL your Monitors/Rules must have that label**.

---

## ❓ Troubleshooting

### Target not showing up in Prometheus?

1. **Check Labels:**
   Does your `ServiceMonitor`/`PodMonitor` have the `release` label matching your Prometheus install?
   ```bash
   kubectl get servicemonitors --show-labels
   ```

2. **Check Selector:**
   Does the `selector` inside the Monitor match your Service/Pod labels?
   ```yaml
   spec:
     selector:
       matchLabels:
         app: my-app # Must match labels on the Service (for ServiceMonitor) or Pod (for PodMonitor)
   ```

3. **Check Port Name:**
   The `port:` field typically refers to the **name** of the port (e.g., `web`, `http-metrics`), not the number (8080).

4. **Check Status:**
   Review the Operator logs if it's rejecting the configuration.
   ```bash
   kubectl logs -l app.kubernetes.io/name=prometheus-operator -n monitoring
   ```
