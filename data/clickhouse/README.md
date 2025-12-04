# ClickHouse on Kubernetes

> **Description:** Fast open-source OLAP database management system.
> **Version:** 23.8 (Example)
> **[Ubuntu Cluster Guide](./UBUNTU_CLUSTER.md)**: For Bare Metal/VM installation.

---

## 🏗️ Architecture

- **ClickHouse Server:** Stores data and processes queries.
- **Zookeeper:** Used for replication coordination and distributed DDL.
- **Shards & Replicas:** Data is distributed across shards and replicated for high availability.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.23+
- Helm 3+
- `clickhouse-client` (Optional but recommended).

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### 2. Install ClickHouse
```bash
helm upgrade --install clickhouse bitnami/clickhouse \
  --namespace clickhouse \
  --create-namespace \
  --values values.yaml \
  --version 4.1.0
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `shards` | `2` | Number of shards. |
| `replicaCount` | `2` | Replicas per shard. |
| `zookeeper.enabled` | `true` | Enable Zookeeper for replication. |
| `persistence.enabled` | `true` | Persist data. |

---

## 💻 Usage

### Connect via Client
```bash
kubectl run clickhouse-client --rm --tty -i --restart='Never' --image docker.io/bitnami/clickhouse:23.8 --env="CLICKHOUSE_PASSWORD=your-password" --command -- clickhouse-client --host clickhouse --password
```

### Create Table (MergeTree)
```sql
CREATE TABLE visits (
    id UInt64,
    duration UInt32,
    url String,
    created_at DateTime
) ENGINE = MergeTree()
ORDER BY id;
```

### Insert Data
```sql
INSERT INTO visits VALUES (1, 10, 'http://example.com', now());
```

### Query Data
```sql
SELECT url, count() FROM visits GROUP BY url;
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n clickhouse
```

### 2. Check Cluster Status
Inside `clickhouse-client`:
```sql
SELECT * FROM system.clusters;
```

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade clickhouse bitnami/clickhouse -n clickhouse --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall clickhouse -n clickhouse
```
