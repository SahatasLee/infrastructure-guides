# KEDA POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `keda` namespace exists.
- [ ] **Helm Repo Added**: KEDA repo added.
- [ ] **Installation**: KEDA installed successfully via Helm.

## 2. Component Verification
- [ ] **Pods Running**: `keda-operator` and `keda-metrics-apiserver` pods are `Running`.
- [ ] **API Service**: `v1beta1.external.metrics.k8s.io` is available (check `kubectl get apiservice`).

## 3. Functional Testing
- [ ] **ScaledObject Created**: Apply a test `ScaledObject` (e.g., Cron scaler).
- [ ] **Scaling Verify**: Confirm HPA is created and target workload scales up/down based on the trigger.
- [ ] **TriggerAuth**: (Optional) Verify `TriggerAuthentication` works for secured scalers (e.g., SQS, Kafka).

## 4. Operational Validation
- [ ] **Logs**: Check operator logs for errors.
- [ ] **Metrics**: (Optional) Verify KEDA metrics are exposed to Prometheus.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall keda -n keda`.
