# GitLab POC Checklist

## Phase 1: Infrastructure

- [ ] **Helm Deployment**: All pods in `gitlab` namespace are `Running`.
    - Webservice, Sidekiq, Gitaly, Redis, Postgres, MinIO (if bundled).
- [ ] **Ingress**: `gitlab.example.com` is accessible via HTTPS.

## Phase 2: Access & Configuration

- [ ] **Root Login**: Can login with `root` and initial password.
- [ ] **License**: License uploaded (if Enterprise) or CE active.
- [ ] **Runner Registration**:
    - [ ] Shared Runner is registered and `Online` in Admin Area -> Runners.

## Phase 3: Functional Testing

- [ ] **Project Creation**: Create a new project "test-project".
- [ ] **Git Operations**:
    - [ ] `git clone` via HTTP/SSH.
    - [ ] `git push` a change.
- [ ] **CI Pipeline**:
    - [ ] Add `.gitlab-ci.yml` with a simple `echo "Hello World"` job.
    - [ ] Verify pipeline succeeds.

## Phase 4: Operations

- [ ] **Backup**: Run backup utility and verify tarball in S3/MinIO.
- [ ] **Monitoring**: Verify metrics are exposed at `/-/metrics`.
