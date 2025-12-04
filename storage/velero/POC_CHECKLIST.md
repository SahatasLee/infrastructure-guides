# Velero POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `velero` namespace exists.
- [ ] **Object Storage Ready**: S3/MinIO bucket `velero-backups` created.
- [ ] **Credentials Created**: `cloud-credentials` secret exists in `velero` namespace.
- [ ] **Helm Repo Added**: VMware Tanzu repo added.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: `velero` server and `node-agent` pods are `Running`.
- [ ] **BSL Available**: `velero backup-location get` shows `Phase: Available`.

## 3. Functional Testing
- [ ] **Backup Create**: Can create a manual backup.
  ```bash
  velero backup create test-backup --include-namespaces default
  ```
- [ ] **Backup Complete**: Backup status becomes `Completed`.
  ```bash
  velero backup describe test-backup
  ```
- [ ] **Simulate Disaster**: Delete a resource (e.g., a Deployment) in the backed-up namespace.
- [ ] **Restore Create**: Can restore from the backup.
  ```bash
  velero restore create --from-backup test-backup
  ```
- [ ] **Restore Complete**: Restore status becomes `Completed` and resource is back.

## 4. Operational Validation
- [ ] **Schedule Test**: Scheduled backup triggers at the correct time.
- [ ] **PVC Backup**: Verify that Persistent Volumes are backed up (if using Node Agent).
- [ ] **Retention Policy**: Verify TTL settings on backups.

## 5. Cleanup
- [ ] **Delete Backups**: `velero backup delete test-backup`
- [ ] **Uninstall**: `helm uninstall velero -n velero`
