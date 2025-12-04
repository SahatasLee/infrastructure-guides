# ArgoCD POC Checklist

## Phase 1: Infrastructure

- [ ] **Helm Deployment**: Pods (server, repo-server, controller, redis, dex) are `Running`.
- [ ] **Ingress**: `argocd.example.com` is accessible.

## Phase 2: Access & Configuration

- [ ] **Admin Login**: Can login with `admin` and initial password.
- [ ] **CLI Access**: `argocd login` works.

## Phase 3: Functional Testing

- [ ] **Repository Connection**:
    - [ ] Connect a public Git repo (e.g., `https://github.com/argoproj/argocd-example-apps`).
    - [ ] Status is `Successful`.
- [ ] **Application Creation**:
    - [ ] Create "guestbook" app from the example repo.
    - [ ] Sync the app.
    - [ ] Verify resources are created in the cluster.
- [ ] **Self-Heal**:
    - [ ] Manually delete a deployment managed by ArgoCD.
    - [ ] Verify ArgoCD detects "OutOfSync" and restores it (if auto-sync enabled).

## Phase 4: Operations

- [ ] **RBAC**: Create a read-only user and verify permissions.
