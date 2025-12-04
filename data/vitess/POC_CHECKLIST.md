# Vitess POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `vitess` namespace exists.
- [ ] **Helm Repo Added**: Vitess repo added.

## 2. Deployment & Installation
- [ ] **Operator Installed**: Vitess Operator pod is `Running`.
- [ ] **Cluster CRD Applied**: `VitessCluster` CRD applied.
- [ ] **Cluster Pods Ready**: `vtgate`, `vtctld`, and `vttablet` pods are `Running`.

## 3. Functional Testing
- [ ] **MySQL Connection**: Can connect to VTGate using a MySQL client.
- [ ] **Schema Initialization**: Table creation (schema) applied successfully.
- [ ] **CRUD Operations**: Can INSERT and SELECT data.
- [ ] **Dashboard Access**: Can access VTctld dashboard.

## 4. Operational Validation
- [ ] **Failover**: Kill a master tablet pod, verify failover to replica (if configured).
- [ ] **Scaling**: Add more replicas in the CRD and verify new pods start.

## 5. Cleanup
- [ ] **Cluster Deletion**: `kubectl delete -f cluster.yaml` executed.
- [ ] **Uninstall**: `helm uninstall vitess -n vitess` executed.
