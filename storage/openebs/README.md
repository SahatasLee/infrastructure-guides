# OpenEBS

> **Description:** Container Attached Storage (CAS) for Kubernetes. Provides LocalPV and Replicated storage engines.
> **Version:** Chart v3.x (OpenEBS v3.x)
> **Last Updated:** 2025-12-04

## 📋 Prerequisites

List requirements before installation:
- [ ] Kubernetes Cluster v1.20+
- [ ] iSCSI initiator installed on nodes (for some engines)
- [ ] Unmounted block devices (for LocalPV Device)

---

## 🏗️ Architecture

OpenEBS provides multiple storage engines. We primarily use **LocalPV Hostpath** for simple, fast, node-local storage.

```mermaid
graph TD;
    Pod -->|PVC| PV;
    PV -->|LocalPV| NodeDisk[Node Disk (HostPath)];
```

---

## 🚀 Installation Guide

### Option 1: Installation via Helm

```bash
# 1. Add Helm Repo
helm repo add openebs https://openebs.github.io/charts
helm repo update

# 2. Create Namespace
kubectl create ns openebs

# 3. Install/Upgrade
helm upgrade --install openebs openebs/openebs \
  -n openebs \
  -f values.yaml
```

---

## ⚙️ Configuration Details

**Key Configurations** (values.yaml)

| Parameter | Description | Default | Recommended |
| :--- | :--- | :--- | :--- |
| `localprovisioner.enabled` | Enable LocalPV Hostpath | `true` | `true` |
| `ndm.enabled` | Enable Node Disk Manager | `true` | `true` |
| `jiva.enabled` | Enable Jiva (Replicated) | `false` | `false` (Deprecated) |
| `cstor.enabled` | Enable cStor (Replicated) | `false` | `false` (Complex) |

---

## ✅ Verification & Usage

### 1. Verify Storage Classes
```bash
kubectl get sc
# Expected: openebs-hostpath, openebs-device
```

### 2. Create a Test PVC
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: local-hostpath-pvc
spec:
  storageClassName: openebs-hostpath
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

---

## 🔧 Maintenance & Operations

- **Upgrading**: `helm upgrade ...`.
- **Node Maintenance**: LocalPV data is tied to the node. Drain node carefully.

---

## 📊 Monitoring & Alerts

- **Metrics**: OpenEBS exports metrics for Prometheus.

---

## ❓ Troubleshooting

Common issues and fixes:

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| PVC Pending | No node matches topology | Check node labels |
| Pod Scheduling Failed | Node out of disk | Free up space |

---

## 📚 References

- [OpenEBS Documentation](https://openebs.io/docs/)
