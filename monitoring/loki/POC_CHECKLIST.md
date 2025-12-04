# Loki POC Checklist

## Phase 1: Infrastructure

- [ ] **Pod Status**: Loki and Alloy pods are `Running`.
- [ ] **Gateway**: Loki Gateway (Nginx) is accessible.

## Phase 2: Functional Testing

- [ ] **Log Ingestion**:
    - [ ] Verify Alloy is scraping logs from pods.
    - [ ] Check Alloy logs for errors.
- [ ] **Querying**:
    - [ ] In Grafana, select Loki data source.
    - [ ] Run query `{namespace="logging"}`.
    - [ ] Verify logs are displayed.
- [ ] **Live Tailing**:
    - [ ] Use "Live" mode in Grafana Explore.
    - [ ] Verify new logs appear in real-time.

## Phase 3: Operations

- [ ] **Persistence**:
    - [ ] Verify chunks are stored in filesystem/S3.
