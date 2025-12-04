# GitLab (Self-Hosted)

> **Description:** The One DevOps Platform. Complete CI/CD toolchain, source code management, and more.
> **Version:** Chart v7.x (GitLab v16.x)
> **Last Updated:** 2025-12-04

## 📋 Prerequisites

List requirements before installation:
- [ ] Kubernetes Cluster v1.25+
- [ ] Minimum RAM: 8GB (for minimal setup) / 16GB+ (recommended)
- [ ] Helm v3+
- [ ] Storage Class (Standard/Premium)
- [ ] Domain Name & TLS Certificate

---

## 🏗️ Architecture

GitLab is a complex application composed of many services (Gitaly, Sidekiq, Webservice, Postgres, Redis, MinIO).

```mermaid
graph TD;
    User -->|HTTPS| Ingress;
    Ingress --> Webservice;
    Webservice --> Gitaly[Gitaly (Git Storage)];
    Webservice --> Postgres[(PostgreSQL)];
    Webservice --> Redis[(Redis)];
    Sidekiq --> Redis;
    Sidekiq --> Postgres;
    Runner -->|Jobs| Webservice;
```

---

## 🚀 Installation Guide

### Option 1: Installation via Helm

```bash
# 1. Add Helm Repo
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# 2. Create Namespace
kubectl create ns gitlab

# 3. Install/Upgrade
# Note: This can take 10-15 minutes to become ready.
helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  -f values.yaml
```

---

## ⚙️ Configuration Details

**Key Configurations** (values.yaml)

| Parameter | Description | Default | Recommended |
| :--- | :--- | :--- | :--- |
| `global.hosts.domain` | Base domain for GitLab | `example.com` | `your-domain.com` |
| `global.edition` | GitLab Edition | `ce` | `ce` (Community) |
| `certmanager.install` | Install Cert-Manager | `true` | `false` (Use existing) |
| `prometheus.install` | Install Prometheus | `true` | `false` (Use existing) |
| `gitlab-runner.install` | Install GitLab Runner | `true` | `true` |

---

## ✅ Verification & Usage

### 1. Get Initial Root Password
```bash
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode ; echo
```

### 2. Access GitLab
Navigate to `https://gitlab.your-domain.com` and login with `root` and the password above.

### 3. Verify Components
```bash
kubectl get pods -n gitlab
# Ensure all pods (webservice, sidekiq, gitaly, etc.) are Running.
```

---

## 🔧 Maintenance & Operations

- **Upgrading**: Follow the [official upgrade path](https://docs.gitlab.com/ee/update/index.html#upgrade-paths). Do not skip major versions.
- **Backup**:
  ```bash
  # Trigger backup via toolbox pod
  kubectl exec -it <toolbox-pod> -n gitlab -- backup-utility
  ```

---

## 📊 Monitoring & Alerts

- **Metrics**: GitLab exports extensive metrics. Configure your Prometheus to scrape the GitLab endpoints.
- **Dashboards**: Import official GitLab Grafana dashboards.

---

## ❓ Troubleshooting

Common issues and fixes:

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| `webservice` pod pending | Insufficient resources | Add nodes or reduce requests |
| `502 Bad Gateway` | Webservice starting up | Wait 5-10 minutes |
| Gitaly crash | Storage permission issues | Check PVC permissions |

---

## 📚 References

- [GitLab Helm Chart Docs](https://docs.gitlab.com/charts/)
- [Architecture Overview](https://docs.gitlab.com/ee/development/architecture.html)
