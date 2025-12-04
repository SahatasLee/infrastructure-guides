# Longhorn

> **Description:** Cloud-native distributed block storage for Kubernetes. Easy to use, supports snapshots and backups.
> **Version:** Chart v1.5.x (Longhorn v1.5.x)
> **Last Updated:** 2025-12-04

## 📋 Prerequisites

List requirements before installation:
- [ ] Kubernetes Cluster v1.21+
- [ ] `open-iscsi` installed on all nodes
- [ ] `nfs-common` (or equivalent) installed on all nodes (for RWX volumes)

---

## 🏗️ Architecture

Longhorn creates a dedicated controller and set of replicas for each volume.

```mermaid
graph TD;
    Pod -->|Mount| Volume;
    Volume -->|IO| Engine;
    Engine -->|Replicate| Replica1[Replica 1 (Node A)];
    Engine -->|Replicate| Replica2[Replica 2 (Node B)];
    Engine -->|Replicate| Replica3[Replica 3 (Node C)];
```

---

## 🚀 Installation Guide

### Option 1: Installation via Helm

```bash
# 1. Add Helm Repo
helm repo add longhorn https://charts.longhorn.io
helm repo update

# 2. Create Namespace
kubectl create ns longhorn-system

# 3. Install/Upgrade
helm upgrade --install longhorn longhorn/longhorn \
  -n longhorn-system \
  -f values.yaml
```

---

## ⚙️ Configuration Details

**Key Configurations** (values.yaml)

| Parameter | Description | Default | Recommended |
| :--- | :--- | :--- | :--- |
| `persistence.defaultClass` | Set as default StorageClass | `true` | `true` |
| `defaultSettings.defaultReplicaCount` | Default replicas | `3` | `3` |
| `ingress.enabled` | Enable UI Ingress | `false` | `true` |

---

## ✅ Verification & Usage

### 1. Access UI
Navigate to `https://longhorn.example.com` to view the dashboard.

### 2. Verify Storage Class
```bash
kubectl get sc
# Expected: longhorn (default)
```

---

## 🔧 Maintenance & Operations

- **Upgrading**: `helm upgrade ...`. Longhorn supports live upgrades.
- **Backup**: Configure S3 or NFS backup target in the UI or `values.yaml`.

---

## 📊 Monitoring & Alerts

- **Metrics**: Longhorn exposes metrics at `http://longhorn-backend:9500/metrics`.

---

## ❓ Troubleshooting

Common issues and fixes:

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| Volume Detached | Node failure | Longhorn auto-attaches to new node |
| Installation Failed | Missing iSCSI | Install `open-iscsi` on nodes |

---

## 📚 References

- [Longhorn Documentation](https://longhorn.io/docs/)
