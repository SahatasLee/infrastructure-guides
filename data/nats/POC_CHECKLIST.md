# NATS POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `nats` namespace exists.
- [ ] **Helm Repo Added**: NATS repo added.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: All NATS pods (e.g., 3 replicas) are `Running`.
- [ ] **Cluster Formed**: Logs indicate cluster is formed (e.g., "Cluster connection created").

## 3. Functional Testing
- [ ] **Port Forward**: Can connect to NATS server via port-forward.
- [ ] **Pub/Sub**: Can publish and subscribe to a subject using `nats` CLI.
- [ ] **JetStream Enabled**: `nats account info` shows JetStream is enabled.
- [ ] **Stream Creation**: Can create a JetStream stream.
- [ ] **Persistent Messaging**: Messages are persisted in the stream.

## 4. Operational Validation
- [ ] **Benchmark**: `nats bench` runs successfully.
- [ ] **Resilience**: Cluster remains available if one pod is restarted.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall nats -n nats` executed.
- [ ] **PVC Cleanup**: PVCs deleted (if any).
