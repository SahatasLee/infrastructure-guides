# Kube-Prometheus-Stack POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `monitoring` namespace exists.
- [ ] **Helm Repo Added**: Prometheus Community repo added.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: All pods (Prometheus, Grafana, Alertmanager, Operator) are `Running`.

## 3. Configuration
- [ ] **Persistence**: PVCs are bound for Prometheus and Grafana.
- [ ] **Ingress**: Grafana Ingress is created and has an address (if enabled).

## 4. Functional Testing
- [ ] **Grafana Access**: Can login to Grafana.
- [ ] **Dashboards**: Default dashboards (Node Exporter, Kubernetes) are visible and showing data.
- [ ] **Prometheus Access**: Can access Prometheus UI (port-forward 9090).
- [ ] **Target Discovery**: Prometheus shows targets (Nodes, Kubelet, etc.) as UP.
- [ ] **Alertmanager**: Can access Alertmanager UI (port-forward 9093).

## 5. Troubleshooting
- [ ] **Connection Timeout**: If `curl` hangs, check if `grafana.example.com` resolves to the **Traefik LoadBalancer IP** (`kubectl get svc -n traefik`).
- [ ] **404 Not Found**: If you get a 404, check if the `Ingress` exists and has the correct `ingressClassName: traefik`.
- [ ] **No Data in Dashboards**:
    - Check if `node-exporter` pods are running.
    - Check if the underlying metric exists: `node_cpu_seconds_total`.
    - Check if recording rules are firing: `cluster:node_cpu:ratio_rate5m`.
    - If `cluster=""` returns nothing, try removing the `{cluster=""}` filter, as your cluster might not have a name label configured.

## 6. Cleanup
- [ ] **Uninstall**: `helm uninstall kube-prometheus-stack -n monitoring` executed.
