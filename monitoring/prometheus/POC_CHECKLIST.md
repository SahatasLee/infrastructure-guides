# Prometheus (Standalone) POC Checklist

## Phase 1: Infrastructure

- [ ] **Pod Status**: Prometheus Server pod is `Running`.

## Phase 2: Functional Testing

- [ ] **Target Scraping**:
    - [ ] Verify Prometheus scrapes itself (`up{job="prometheus"}`).
    - [ ] Verify other configured targets (e.g., Node Exporter) are UP.
- [ ] **Querying**:
    - [ ] Run a PromQL query: `rate(prometheus_http_requests_total[5m])`.
    - [ ] Verify graph is generated.

## Phase 3: Operations

- [ ] **Config Reload**:
    - [ ] Change config (e.g., scrape interval).
    - [ ] Trigger reload (`/-/reload` or SIGHUP).
    - [ ] Verify change is applied without restart.
