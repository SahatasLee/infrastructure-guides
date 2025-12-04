# OpenEBS POC Checklist

## Phase 1: Infrastructure

- [ ] **Pod Status**: OpenEBS pods (localpv-provisioner, ndm) are `Running`.
- [ ] **Storage Class**: `openebs-hostpath` exists.
    ```bash
    kubectl get sc openebs-hostpath
    ```

## Phase 2: Functional Testing

- [ ] **Volume Provisioning**:
    - [ ] Create a PVC using `openebs-hostpath`.
    - [ ] Verify PVC is `Bound`.
- [ ] **Pod Usage**:
    - [ ] Deploy a Pod mounting the PVC.
    - [ ] Write data to the mount path.
    - [ ] Verify data persists on the node path (e.g., `/var/openebs/local`).
- [ ] **Persistence**:
    - [ ] Restart the Pod.
    - [ ] Verify data is still accessible.

## Phase 3: Operations

- [ ] **Cleanup**:
    - [ ] Delete PVC.
    - [ ] Verify data is deleted from the node (if ReclaimPolicy is Delete).
