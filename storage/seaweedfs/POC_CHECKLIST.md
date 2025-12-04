# SeaweedFS POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `seaweedfs` namespace exists.
- [ ] **Helm Repo Added**: SeaweedFS repo added.
- [ ] **Storage Class**: Valid storage class confirmed for persistence.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: Master, Volume, and Filer pods are `Running`.
- [ ] **PVCs Bound**: All Persistent Volume Claims are `Bound`.

## 3. Functional Testing
- [ ] **S3 Access**: Can access S3 API via port-forward or Service.
- [ ] **Bucket Creation**: Can create an S3 bucket.
- [ ] **Object Upload**: Can upload a file to the bucket.
- [ ] **Object Download**: Can download the file from the bucket.
- [ ] **Filer UI**: Can access Filer UI (port 8888) and see the uploaded file.

## 4. Operational Validation
- [ ] **Replication**: Data is replicated across volume servers (check Master UI).
- [ ] **Resilience**: System remains available if one Master/Volume pod is killed.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall seaweedfs -n seaweedfs`
- [ ] **PVC Cleanup**: PVCs deleted.
