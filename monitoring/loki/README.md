# Loki & Grafana Alloy

> **Description:** Log aggregation system (Loki) with Grafana Alloy (OpenTelemetry Collector) for log collection.
> **Version:** Loki Chart v5.x, Alloy Chart v0.x
> **Last Updated:** 2025-12-04

## 📋 Prerequisites

List requirements before installation:
- [ ] Kubernetes Cluster v1.21+
- [ ] Helm v3+
- [ ] Object Storage (S3/GCS) for long-term retention (Recommended)

---

## 🏗️ Architecture

**Grafana Alloy** runs as a DaemonSet on every node, collecting logs from pods and sending them to **Loki**.

```mermaid
graph LR;
    Pod -->|Logs| Alloy[Grafana Alloy (Agent)];
    Alloy -->|Push| Loki[Loki Server];
    Grafana -->|Query| Loki;
```

---

## 🚀 Installation Guide

### 1. Install Loki (Single Binary)

```bash
# 1. Add Helm Repo
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# 2. Create Namespace
kubectl create ns logging

# 3. Install Loki
helm upgrade --install loki grafana/loki \
  -n logging \
  -f values-loki.yaml
```

### 2. Option 2: Simple Scalable Deployment (Recommended for Scale)

This mode separates read and write paths for better scalability.

**Prerequisites for MinIO (Storage Backend):**
- **Disk Recommendations:**
    - **MinIO Data:** Use **NVMe SSDs** for high IOPS and low latency. MinIO is performance-sensitive.
    - **Loki WAL/Ingesters:** Also benefit from fast SSDs for write throughput.
- **Bucket Setup:** Ensure the following buckets exist (or allow Loki to create them):
    - `loki-data` (chunks)
    - `loki-ruler`
    - `loki-admin`

```bash
# Install Loki in Simple Scalable mode with MinIO
helm upgrade --install loki grafana/loki \
  -n logging \
  -f values-simple-scalable.yaml
```

### 3. Install Grafana Alloy (Collector)

```bash
# Install Alloy
helm upgrade --install alloy grafana/alloy \
  -n logging \
  -f values-alloy.yaml
```

---

## ⚙️ Configuration Details

**Key Configurations**

| File | Parameter | Description | Recommended |
| :--- | :--- | :--- | :--- |
| `values-loki.yaml` | `deploymentMode` | Deployment mode | `SingleBinary` (Simple) or `Distributed` |
| `values-loki.yaml` | `loki.storage.type` | Storage type | `filesystem` (Test) or `s3` (Prod) |
| `values-alloy.yaml` | `alloy.config` | Alloy pipeline config | Define `loki.write` |

---

## ✅ Verification & Usage

### 1. Access Grafana
Use your existing Grafana instance. Add a **Loki** data source with URL `http://loki-gateway.logging.svc.cluster.local`.

### 2. Query Logs
In Grafana Explore, select **Loki** and query `{namespace="logging"}`.

---

## 🔧 Maintenance & Operations

- **Retention**: Configure `retention_period` in `values-loki.yaml`.
- **Alloy**: Alloy uses a River configuration syntax. Update `values-alloy.yaml` to add more scrape targets or processors.

---

## 📊 Monitoring & Alerts

- **Loki**: Exposes metrics for Prometheus.
- **Alloy**: Exposes internal metrics.

---

## ❓ Troubleshooting

Common issues and fixes:

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| No Logs | Alloy config error | Check Alloy logs/UI |
| Loki OOM | High ingestion | Increase memory or scale up |

---

## 📚 References

- [Grafana Loki Docs](https://grafana.com/docs/loki/latest/)
- [Grafana Alloy Docs](https://grafana.com/docs/alloy/latest/)
