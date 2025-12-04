# Longhorn POC Checklist

## Phase 1: Infrastructure

- [ ] **Pod Status**: Longhorn pods (manager, engine, ui) are `Running`.
- [ ] **Ingress**: `longhorn.example.com` is accessible.

## Phase 2: Functional Testing

- [ ] **Volume Creation**:
    - [ ] Create a PVC using `longhorn` StorageClass.
    - [ ] Verify Volume appears in Longhorn UI.
- [ ] **Pod Usage**:
    - [ ] Deploy a Pod mounting the PVC.
    - [ ] Write data.
- [ ] **Replication**:
    - [ ] Check UI to see replicas are distributed across nodes.

## Phase 3: Operations

- [ ] **Snapshot**:
    - [ ] Take a snapshot via UI.
    - [ ] Write new data.
    - [ ] Revert to snapshot.
    - [ ] Verify old data is restored.
- [ ] **Node Failure**:
    - [ ] Cordon/Drain a node with a replica.
    - [ ] Verify Longhorn rebuilds the replica on another node.
