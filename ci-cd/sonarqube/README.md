# SonarQube on Kubernetes

> **Description:** Code Quality and Security tool.
> **Version:** 9.9 LTS (Example)

---

## 🏗️ Architecture

- **SonarQube Server:** The core engine.
- **PostgreSQL Database:** Stores metrics and configuration.
- **Elasticsearch:** Embedded for search (managed by SonarQube).

---

## 📋 Prerequisites

- Kubernetes Cluster 1.23+
- Helm 3+
- PostgreSQL Database (Internal or External)
- Ingress Controller (e.g., NGINX)

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
```

### 2. Install SonarQube
```bash
helm upgrade --install sonarqube sonarqube/sonarqube \
  --namespace sonarqube \
  --create-namespace \
  --values values.yaml \
  --version 8.0.0
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `edition` | `community` | Community, Developer, or Enterprise. |
| `postgresql.enabled` | `true` | Use internal PostgreSQL. |
| `persistence.enabled` | `true` | Persist data. |
| `ingress.enabled` | `true` | Expose via Ingress. |
| `ingress.hosts` | `sonar.example.com` | Domain name. |

---

## 💻 Usage

### Access UI
Navigate to `http://sonar.example.com`.
Default credentials: `admin` / `admin`.

### Run Analysis (Local)
Using Docker:
```bash
docker run \
    --rm \
    -e SONAR_HOST_URL="http://sonar.example.com" \
    -e SONAR_LOGIN="my-token" \
    -v "$(pwd):/usr/src" \
    sonarsource/sonar-scanner-cli
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n sonarqube
```

### 2. Check Logs
```bash
kubectl logs -f statefulset/sonarqube-sonarqube -n sonarqube
```

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade sonarqube sonarqube/sonarqube -n sonarqube --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall sonarqube -n sonarqube
```
