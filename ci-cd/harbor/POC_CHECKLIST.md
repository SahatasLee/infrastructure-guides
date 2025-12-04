# Harbor POC Checklist

## Phase 1: Infrastructure

- [ ] **Helm Deployment**: Pods (core, jobservice, registry, database, redis, trivy) are `Running`.
- [ ] **Ingress**: `harbor.example.com` is accessible.

## Phase 2: Access & Configuration

- [ ] **Admin Login**: Can login with `admin` / `Harbor12345`.
- [ ] **Project Creation**: Create a new project "library" (public) and "private-proj" (private).

## Phase 3: Functional Testing

- [ ] **Docker Login**: `docker login harbor.example.com` succeeds.
- [ ] **Image Push**:
    - [ ] Tag an image: `docker tag alpine harbor.example.com/library/alpine:test`.
    - [ ] Push: `docker push harbor.example.com/library/alpine:test`.
- [ ] **Image Pull**:
    - [ ] Pull: `docker pull harbor.example.com/library/alpine:test`.
- [ ] **Vulnerability Scanning** (if Trivy enabled):
    - [ ] Select image in UI -> Scan.
    - [ ] Verify scan report is generated.

## Phase 4: Operations

- [ ] **Garbage Collection**: Run GC dry-run and verify log.
