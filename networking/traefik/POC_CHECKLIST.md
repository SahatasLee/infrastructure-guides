# Traefik POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `traefik` namespace exists.
- [ ] **Helm Repo Added**: Traefik repo added.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: Traefik pods are `Running`.
- [ ] **Service IP**: Traefik LoadBalancer service has an external IP.

## 3. Functional Testing
- [ ] **Dashboard Access**: Can access dashboard via port-forward.
- [ ] **IngressRoute**: Can create an `IngressRoute` and route traffic.
- [ ] **Standard Ingress**: Can create a standard `Ingress` resource and route traffic.
- [ ] **Middleware**: Can apply middleware (e.g., StripPrefix).

## 4. Cleanup
- [ ] **Uninstall**: `helm uninstall traefik -n traefik` executed.
