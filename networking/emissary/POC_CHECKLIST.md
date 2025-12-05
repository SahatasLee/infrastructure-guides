# Emissary-Ingress POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `emissary` namespace exists.
- [ ] **Helm Repo Added**: Datawire repo added.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: Emissary pods are `Running`.
- [ ] **Service IP**: Emissary LoadBalancer service has an external IP.

## 3. Configuration
- [ ] **Listener Created**: `Listener` CRD applied (HTTP/HTTPS).
- [ ] **Host Created**: `Host` CRD applied.

## 4. Functional Testing
- [ ] **Mapping Created**: `Mapping` CRD created to route traffic.
- [ ] **Routing Verified**: Can access backend service via Emissary IP.
- [ ] **Diagnostics**: Can access diagnostics UI (port-forward 8877).

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall emissary-ingress -n emissary` executed.
