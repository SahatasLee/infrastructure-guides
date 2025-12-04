# Kube-Prometheus-Stack POC Checklist

## Phase 1: Infrastructure

- [ ] **Pod Status**: Prometheus, Alertmanager, Grafana, Node-Exporter, Kube-State-Metrics pods are `Running`.
- [ ] **ServiceMonitors**: Default ServiceMonitors (kubelet, apiserver, etc.) exist.

## Phase 2: Access

- [ ] **Grafana**: Accessible via Port-Forward/Ingress.
- [ ] **Prometheus**: Accessible via Port-Forward/Ingress.
- [ ] **Alertmanager**: Accessible via Port-Forward/Ingress.

## Phase 3: Functional Testing

- [ ] **Metrics Collection**:
    - [ ] In Prometheus UI, query `up`.
    - [ ] Verify targets (Nodes, Kubelet, CoreDNS) are `1` (UP).
- [ ] **Dashboards**:
    - [ ] In Grafana, verify default dashboards (e.g., "Kubernetes / Compute Resources / Cluster") show data.
- [ ] **Alerting**:
    - [ ] Verify default alerts are present in Prometheus "Alerts" tab.
    - [ ] (Optional) Trigger a test alert (e.g., Watchdog) and verify it reaches Alertmanager.

## Phase 4: Operations

- [ ] **Persistence**:
    - [ ] Restart Prometheus pod.
    - [ ] Verify historical data is preserved.
