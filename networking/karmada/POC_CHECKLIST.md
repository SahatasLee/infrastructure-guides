# Karmada POC Checklist

## 1. Infrastructure Setup
- [ ] **Host Cluster Ready**: Kubernetes cluster for Control Plane is ready.
- [ ] **Member Clusters Ready**: At least one other cluster is available to join.
- [ ] **CLI Installed**: `karmadactl` is installed.

## 2. Deployment & Installation
- [ ] **Init Command**: `karmadactl init` executed successfully.
- [ ] **Pods Ready**: All Karmada system pods (`karmada-apiserver`, `karmada-controller-manager`, etc.) are `Running`.

## 3. Cluster Management
- [ ] **Join Cluster**: `karmadactl join` executed successfully.
- [ ] **Cluster Status**: `kubectl get clusters` shows the member cluster as `Ready`.

## 4. Workload Propagation
- [ ] **Resource Creation**: Created a Deployment in Karmada API Server.
- [ ] **Policy Creation**: Created a `PropagationPolicy` to target the member cluster.
- [ ] **Distribution Verification**: Verified that the Deployment exists in the member cluster.
- [ ] **Override Policy (Optional)**: Tested `OverridePolicy` to change configuration for specific clusters.

## 5. Cleanup
- [ ] **Unjoin**: `karmadactl unjoin` executed.
- [ ] **Deinit**: `karmadactl deinit` executed.
