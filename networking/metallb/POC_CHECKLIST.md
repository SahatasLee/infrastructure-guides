# MetalLB POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `metallb-system` namespace exists.
- [ ] **Helm Repo Added**: MetalLB repo added.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: Controller and Speaker pods are `Running`.

## 3. Configuration
- [ ] **IP Pool Created**: `IPAddressPool` CRD applied with valid IP range.
- [ ] **Advertisement Created**: `L2Advertisement` (or BGP) CRD applied.

## 4. Functional Testing
- [ ] **Service Exposure**: Can create a service with `type: LoadBalancer`.
- [ ] **IP Assignment**: Service is assigned an external IP from the pool.
- [ ] **Connectivity**: Can access the service using the assigned external IP.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall metallb -n metallb-system` executed.
