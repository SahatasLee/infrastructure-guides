# Grafana Tempo POC Checklist

Use this checklist to validate your Grafana Tempo deployment for Proof of Concept (POC) purposes.

## Phase 1: Infrastructure & Deployment

- [ ] **S3 Bucket Created**: Verify S3 bucket exists and credentials have read/write permissions.
- [ ] **Helm Deployment**: Tempo pods are `Running` and `Ready`.
    ```bash
    kubectl get pods -n monitoring -l app.kubernetes.io/name=tempo
    ```
- [ ] **Service Access**: Verify Tempo ports are open (4317 for OTLP gRPC, 4318 for OTLP HTTP, 3100 for Query).

## Phase 2: Integration

- [ ] **Grafana Data Source**:
    - [ ] Add "Tempo" data source in Grafana.
    - [ ] URL: `http://tempo.monitoring.svc.cluster.local:3100`.
    - [ ] "Save & Test" returns "Data source is working".
- [ ] **Log Correlation (Loki)**:
    - [ ] In Loki Data Source settings, add "Derived Fields".
    - [ ] Name: `traceID`, Regex: `trace_id=(\w+)`, Query: `${__value.raw}`.
    - [ ] Link to Tempo data source.

## Phase 3: Functional Testing

- [ ] **Trace Ingestion**:
    - [ ] Send sample traces using an app or `telemetrygen`.
    - [ ] Verify metrics `tempo_distributor_spans_received_total` is increasing.
- [ ] **Trace Visualization**:
    - [ ] In Grafana Explore, select Tempo.
    - [ ] Run a "Search" query (e.g., by Service Name).
    - [ ] Click a Trace ID and verify the Waterfall view loads.
- [ ] **Service Graph**:
    - [ ] (Optional) Enable Service Graph generation in Tempo/Alloy.
    - [ ] Verify "Node Graph" view in Grafana.

## Phase 4: Operations & Persistence

- [ ] **S3 Persistence**:
    - [ ] Wait for ~1 hour (or force flush).
    - [ ] Verify blocks are created in the S3 bucket.
- [ ] **Retention**:
    - [ ] Verify old blocks are deleted after the configured retention period (test with short retention like `1h`).
- [ ] **Resilience**:
    - [ ] Kill a Tempo pod and verify it recovers without data loss (if using WAL/PVC).

## Phase 5: Performance (Basic)

- [ ] **Resource Usage**: Check CPU/Memory usage of Tempo pods under load.
- [ ] **Latency**: Check `tempo_request_duration_seconds` for query performance.
