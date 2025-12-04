# Linkerd POC Checklist

## 1. Infrastructure Setup
- [ ] **Cluster Ready**: Kubernetes cluster is running.
- [ ] **CLI Installed**: `linkerd` CLI is installed and in PATH.
- [ ] **Pre-check**: `linkerd check --pre` passes.

## 2. Deployment & Installation
- [ ] **CRDs Installed**: Linkerd CRDs applied.
- [ ] **Control Plane Ready**: `linkerd install` executed, pods running in `linkerd` namespace.
- [ ] **Viz Extension Ready**: `linkerd viz install` executed, pods running in `linkerd-viz` namespace.
- [ ] **Post-check**: `linkerd check` passes all checks.

## 3. Functional Testing
- [ ] **Injection**: Target namespace annotated with `linkerd.io/inject=enabled`.
- [ ] **Sidecar Present**: Deployed pods have 2/2 containers (App + `linkerd-proxy`).
- [ ] **Dashboard Access**: `linkerd viz dashboard` opens successfully.
- [ ] **Metrics Visible**: Dashboard shows success rate, RPS, and latency for injected apps.

## 4. Operational Validation
- [ ] **mTLS Verification**: `linkerd viz edges` shows secured connections.
- [ ] **Tap**: `linkerd viz tap` shows live request data.

## 5. Cleanup
- [ ] **Uninstall**: `linkerd uninstall` executed.
