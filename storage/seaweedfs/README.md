# SeaweedFS on Kubernetes

> **Description:** High-performance distributed file system (S3 compatible).
> **Version:** 3.59 (Example)

---

## 🏗️ Architecture

- **Master:** Manages volume servers and volume locations.
- **Volume Server:** Stores actual data (needles).
- **Filer:** Provides file system view and metadata management.
- **S3 Gateway:** Provides S3-compatible API.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.23+
- Helm 3+

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add seaweedfs https://seaweedfs.github.io/seaweedfs/helm
helm repo update
```

### 2. Install SeaweedFS
```bash
helm upgrade --install seaweedfs seaweedfs/seaweedfs \
  --namespace seaweedfs \
  --create-namespace \
  --values values.yaml \
  --version 4.0.401
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `master.replicas` | `3` | HA for Master. |
| `volume.replicas` | `3` | Number of Volume Servers. |
| `filer.replicas` | `2` | HA for Filer. |
| `s3.enabled` | `true` | Enable S3 Gateway. |
| `persistence.enabled` | `true` | Persist data. |

---

## 💻 Usage

### Access S3 API
Forward the port:
```bash
kubectl port-forward svc/seaweedfs-s3 8333:8333 -n seaweedfs
```

### Access Filer UI
Forward the port:
```bash
kubectl port-forward svc/seaweedfs-filer 8888:8888 -n seaweedfs
```

### Access Volume UI
Forward the port:
```bash
kubectl port-forward svc/seaweedfs-volume 8080:8080 -n seaweedfs
```

### Access Master UI
Forward the port:
```bash
kubectl port-forward svc/seaweedfs-master 9333:9333 -n seaweedfs
```

Configure AWS CLI:
```bash
aws configure set aws_access_key_id any
aws configure set aws_secret_access_key any
aws configure set region us-east-1
```

List buckets:
```bash
aws --endpoint-url http://localhost:8333 s3 ls
```

### Create Bucket and Upload
```bash
aws --endpoint-url http://localhost:8333 s3 mb s3://my-bucket
aws --endpoint-url http://localhost:8333 s3 cp test.txt s3://my-bucket/
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n seaweedfs
```

### 2. Check Volume Status
Access Master UI (port 9333) to see volume topology.

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade seaweedfs seaweedfs/seaweedfs -n seaweedfs --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall seaweedfs -n seaweedfs
```
