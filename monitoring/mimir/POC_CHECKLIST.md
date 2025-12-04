# Grafana Mimir POC Checklist

## Phase 1: Infrastructure Setup

- [ ] **Helm Installation**:
    - [ ] Add Grafana Helm repo.
    - [ ] Create `mimir` namespace.
    - [ ] Install Mimir using `values.yaml`.
- [ ] **Pod Status**: All Mimir components (ingester, distributor, querier, etc.) are `Running`.
- [ ] **Object Storage**:
    - [ ] Verify connection to Object Storage (S3/MinIO).
    - [ ] Verify buckets are created (if using MinIO).

## Phase 2: Functional Testing

- [ ] **Remote Write**:
    - [ ] Configure Prometheus to remote write to Mimir (`http://mimir-nginx.mimir.svc:80/api/v1/push`).
    - [ ] Verify metrics are reaching Mimir (check distributor logs/metrics).
- [ ] **Querying**:
    - [ ] Add Mimir as a Prometheus data source in Grafana.
    - [ ] Run a PromQL query (e.g., `up`) and verify results.
- [ ] **Alerting**:
    - [ ] Configure an alert rule in Mimir (via Ruler).
    - [ ] Trigger the alert and verify it reaches Alertmanager.

## Phase 3: Operational Validation

- [ ] **Persistence**:
    - [ ] Restart ingester pods.
    - [ ] Verify no data loss (WAL replay).
- [ ] **Scaling**:
    - [ ] Scale up queriers to handle increased read load.
    - [ ] Scale up ingesters (ensure replication factor is maintained).
- [ ] **Compaction**:
    - [ ] Verify compactor is running and merging blocks in object storage.

## Phase 4: Cleanup

- [ ] **Uninstall**: Helm uninstall Mimir.
- [ ] **Resource Removal**: Delete PVCs and Object Storage buckets.
