# NATS on Kubernetes

> **Description:** High-performance messaging system (Pub/Sub, Request-Reply, JetStream).
> **Version:** 2.10.0 (Example)

---

## 🏗️ Architecture

- **NATS Server:** The core messaging server.
- **JetStream:** Built-in persistence engine for NATS (replaces NATS Streaming).
- **Leaf Nodes:** Extends the cluster to edge locations.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.20+
- Helm 3+
- `nats` CLI installed (Optional but recommended).

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm repo update
```

### 2. Install NATS (with JetStream)
```bash
helm upgrade --install nats nats/nats \
  --namespace nats \
  --create-namespace \
  --values values.yaml \
  --version 1.1.0
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `config.cluster.enabled` | `true` | Enable clustering. |
| `config.jetstream.enabled` | `true` | Enable JetStream persistence. |
| `config.jetstream.memoryStore` | `1Gi` | Max memory for streams. |
| `config.jetstream.fileStore` | `10Gi` | Max disk storage for streams. |

---

## 💻 Usage

### Port Forward
```bash
kubectl port-forward svc/nats 4222:4222 -n nats
```

### Basic Pub/Sub (CLI)
**Subscriber:**
```bash
nats sub "orders.>"
```

**Publisher:**
```bash
nats pub orders.new "Order #1234"
```

### JetStream Example
**Create Stream:**
```bash
nats stream add ORDERS --subjects "orders.>"
```

**Publish Persistent Message:**
```bash
nats pub orders.new "Persistent Order"
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n nats
# Should see 3 pods (if HA)
```

### 2. Check Cluster Status
```bash
nats server list
```

### 3. Benchmark
```bash
nats bench orders
```

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade nats nats/nats -n nats --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall nats -n nats
```
