# Elasticsearch on Kubernetes

> **Description:** Distributed, RESTful search and analytics engine.
> **Version:** 8.5.1 (Example)

---

## 🏗️ Architecture

This deployment uses a **Simple Scalable** architecture where nodes act as both **Master** and **Data** nodes.

- **Replicas:** 3 Nodes
- **Roles:** `master`, `data`, `ingest`
- **Storage:** Persistent Volume per node.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.23+
- Helm 3+
- Storage Class (e.g., `gp2`, `standard`)

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add elastic https://helm.elastic.co
helm repo update
```

### 2. Install Elasticsearch
```bash
helm upgrade --install elasticsearch elastic/elasticsearch \
  --namespace monitoring \
  --create-namespace \
  --values values.yaml \
  --version 8.5.1
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `replicas` | `3` | High Availability setup. |
| `resources.requests.memory` | `2Gi` | Guaranteed memory. |
| `resources.limits.memory` | `4Gi` | Max memory. |
| `volumeClaimTemplate.storage` | `30Gi` | Disk space per node. |
| `antiAffinity` | `hard` | Ensure nodes are on different hosts. |

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n monitoring -l app=elasticsearch-master
```

### 2. Check Cluster Health
Forward the port and check health:
```bash
kubectl port-forward svc/elasticsearch-master 9200:9200 -n monitoring
curl -u "elastic:PASSWORD" -k "https://localhost:9200/_cluster/health?pretty"
```
*Note: Retrieve the password from the secret `elasticsearch-master-credentials`.*

---

## 🧹 Maintenance

### Rolling Restart
```bash
kubectl rollout restart statefulset/elasticsearch-master -n monitoring
```

### Scale Out
Update `replicas` in `values.yaml` and apply:
```bash
helm upgrade elasticsearch elastic/elasticsearch -n monitoring -f values.yaml
```
