# Thanos POC Checklist

## Phase 1: Infrastructure

- [ ] **Pod Status**: Thanos Query, Store, Compactor pods are `Running`.
- [ ] **Sidecar**: Prometheus pod has Thanos Sidecar container running.

## Phase 2: Functional Testing

- [ ] **Global Query**:
    - [ ] Access Thanos Query UI.
    - [ ] Verify "Stores" page shows the Sidecar and Store Gateway.
    - [ ] Run a query. Verify data comes from both recent (Sidecar) and historical (Store) sources.
- [ ] **Object Storage**:
    - [ ] Verify Sidecar uploads blocks to S3.
    - [ ] Verify Store Gateway can read from S3.

## Phase 3: Operations

- [ ] **Compaction**:
    - [ ] Verify Compactor is running and processing blocks (check logs).
    - [ ] Verify downsampled blocks appear in S3.
