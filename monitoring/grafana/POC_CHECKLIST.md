# Grafana (Standalone) POC Checklist

## Phase 1: Infrastructure

- [ ] **Pod Status**: Grafana pod is `Running`.

## Phase 2: Functional Testing

- [ ] **Data Source**:
    - [ ] Add a Data Source (e.g., Prometheus).
    - [ ] "Save & Test" succeeds.
- [ ] **Dashboard**:
    - [ ] Import a dashboard (e.g., Node Exporter Full).
    - [ ] Verify panels populate with data.
- [ ] **Users**:
    - [ ] Create a new user (if not using anonymous auth).
    - [ ] Login as new user.

## Phase 3: Operations

- [ ] **Persistence**:
    - [ ] Restart Grafana pod.
    - [ ] Verify Dashboards/Users/Data Sources persist.
