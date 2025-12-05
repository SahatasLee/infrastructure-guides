# Falco POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `falco` namespace exists.
- [ ] **Helm Repo Added**: Falco repo added.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: Falco DaemonSet pods are `Running` on all nodes.
- [ ] **Sidekick Ready**: Falco Sidekick (and UI if enabled) pods are `Running`.
- [ ] **Driver Loaded**: Logs confirm eBPF probe or Kernel module loaded successfully.

## 3. Functional Testing
- [ ] **Web UI Access**: Can access Falco Sidekick UI via port-forward.
- [ ] **Rule Trigger**: Can trigger a default rule (e.g., `cat /etc/shadow` or spawning a shell).
- [ ] **Alert Generation**: Alert appears in logs and/or Web UI.

## 4. Operational Validation
- [ ] **Resource Usage**: Falco pods are within resource limits.
- [ ] **No CrashLoops**: Pods are stable.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall falco -n falco` executed.
