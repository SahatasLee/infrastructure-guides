# Kyverno POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `kyverno` namespace exists.
- [ ] **Helm Repo Added**: Kyverno repo added.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: All controller pods are `Running`.

## 3. Functional Testing
- [ ] **Policy Creation**: Can apply a `ClusterPolicy`.
- [ ] **Validation (Enforce)**: Policy blocks non-compliant resources.
- [ ] **Validation (Audit)**: Policy allows non-compliant resources but reports violation.
- [ ] **Mutation**: Policy mutates a resource (e.g., adds a label).
- [ ] **Generation**: Policy generates a resource (e.g., NetworkPolicy).

## 4. Operational Validation
- [ ] **Metrics**: Prometheus metrics are being scraped (if enabled).
- [ ] **High Availability**: Admission works even if one pod is killed.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall kyverno -n kyverno`
- [ ] **CRD Cleanup**: CRDs deleted (optional).
