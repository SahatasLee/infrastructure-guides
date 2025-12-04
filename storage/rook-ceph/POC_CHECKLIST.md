# Rook-Ceph POC Checklist

## Phase 1: Infrastructure

- [ ] **Operator Status**: Rook Operator is `Running`.
- [ ] **Cluster Status**: Ceph Cluster (Mon, Mgr, OSD) is `Health_OK`.
    ```bash
    kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph status
    ```

## Phase 2: Functional Testing

- [ ] **Block Storage (RBD)**:
    - [ ] Create PVC with `rook-ceph-block`.
    - [ ] Mount to Pod and write data.
- [ ] **Object Storage (RGW)** (if enabled):
    - [ ] Create ObjectStore and Bucket.
    - [ ] Upload/Download file via S3 API.
- [ ] **File System (CephFS)** (if enabled):
    - [ ] Create PVC with `rook-ceph-filesystem`.
    - [ ] Mount to multiple pods (ReadWriteMany).

## Phase 3: Operations

- [ ] **Dashboard**: Access Ceph Dashboard.
- [ ] **OSD Failure**:
    - [ ] Simulate disk failure (advanced).
    - [ ] Verify Ceph heals (rebalances).
