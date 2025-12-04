# Istio POC Checklist

## 1. Infrastructure Setup
- [ ] **Cluster Ready**: Kubernetes cluster is running and accessible.
- [ ] **CLI Installed**: `istioctl` is installed and in PATH.

## 2. Deployment & Installation
- [ ] **Install Command**: `istioctl install` executed successfully.
- [ ] **Control Plane Ready**: `istiod` pod is `Running` in `istio-system`.
- [ ] **Ingress Gateway Ready**: `istio-ingressgateway` pod is `Running`.

## 3. Functional Testing
- [ ] **Namespace Labeling**: Target namespace labeled with `istio-injection=enabled`.
- [ ] **Sidecar Injection**: Deployed pods automatically get the Envoy sidecar (2/2 containers).
- [ ] **Gateway Access**: Can access services via the Ingress Gateway IP/Hostname.
- [ ] **Dashboard Access**: Can access Kiali/Jaeger/Prometheus (if installed via addons).

## 4. Traffic Management
- [ ] **VirtualService**: Can apply a VirtualService to route traffic.
- [ ] **Traffic Splitting**: Can observe traffic split between subsets (e.g., v1/v2).

## 5. Cleanup
- [ ] **Uninstall**: `istioctl uninstall` executed.
- [ ] **Namespace Cleanup**: `istio-system` namespace deleted.
