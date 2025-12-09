# OpenCost POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `opencost` namespace exists.
- [ ] **Helm Repo Added**: OpenCost repo added.
- [ ] **Prometheus Ready**: Prometheus is running and accessible from the `opencost` namespace.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: `opencost` pod is `Running`.

## 3. Functional Testing
- [ ] **UI Access**: Can access the UI via port-forward or Ingress.
- [ ] **Prometheus Connection**: OpenCost logs show successful connection to Prometheus.
- [ ] **Data Visibility**: Cost data is visible in the UI (may take a few minutes).
- [ ] **Allocation View**: Can view costs broken down by Namespace.

## 4. Operational Validation
- [ ] **Metrics Scrape**: Prometheus is scraping OpenCost metrics (check `opencost_` metrics in Prometheus).

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall opencost -n opencost`
