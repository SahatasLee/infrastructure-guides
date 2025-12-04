# Velero on Kubernetes

> **Description:** Open Source tool to safely backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes.
> **Version:** 1.12.0 (Example)

---

## 🏗️ Architecture

Velero consists of:
- **Velero Server:** Runs in the cluster to process backup/restore operations.
- **Node Agent:** (Optional) Runs on nodes to backup PVC data using Restic/Kopia.
- **Object Storage:** External storage (S3, MinIO, GCS, Azure Blob) to store backups.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.23+
- Helm 3+
- S3-compatible Object Storage (e.g., MinIO, AWS S3)
- Access Key and Secret Key for Object Storage

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm repo update
```

### 2. Create Credentials Secret
Create a file `credentials-velero` with your S3 keys:
```bash
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY
```

Create the secret:
```bash
kubectl create ns velero
kubectl create secret generic cloud-credentials --from-file=cloud=credentials-velero -n velero
```

### 3. Install Velero
```bash
helm upgrade --install velero vmware-tanzu/velero \
  --namespace velero \
  --create-namespace \
  --values values.yaml \
  --version 5.1.0
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `configuration.provider` | `aws` | Use AWS plugin (works for MinIO too). |
| `configuration.backupStorageLocation.bucket` | `velero-backups` | Bucket name. |
| `configuration.backupStorageLocation.config.region` | `minio` | Region (use `minio` for MinIO). |
| `configuration.backupStorageLocation.config.s3Url` | `http://minio.storage:9000` | URL for MinIO/S3. |
| `initContainers` | `velero-plugin-for-aws` | Required plugin for S3. |
| `deployNodeAgent` | `true` | Enable Restic/Kopia for PVC backups. |

---

## 💻 Usage

### Create Backup
```bash
velero backup create my-backup --include-namespaces my-namespace
```

### Create Schedule
```bash
velero schedule create daily-backup --schedule="0 1 * * *" --include-namespaces my-namespace
```

### Restore
```bash
velero restore create --from-backup my-backup
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n velero
```

### 2. Check Backup Location Status
```bash
velero backup-location get
# Should show "Available"
```

---

## 🧹 Maintenance

### Cleanup Backups
```bash
velero backup delete my-backup
```

### Uninstall
```bash
helm uninstall velero -n velero
```
