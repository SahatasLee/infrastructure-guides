# Elasticsearch POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `monitoring` namespace exists.
- [ ] **Helm Repo Added**: Elastic repo added and updated.
- [ ] **Storage Class**: Valid storage class confirmed (e.g., `gp2`, `standard`).
- [ ] **Values Configured**: `values.yaml` updated with correct resources and storage.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: All 3 pods (`elasticsearch-master-0`, `1`, `2`) are `Running` and `1/1`.
- [ ] **PVCs Bound**: All 3 Persistent Volume Claims are `Bound`.

## 3. Functional Testing
- [ ] **Cluster Health**: `_cluster/health` returns `status: green`.
- [ ] **Index Creation**: Can create a test index.
  ```bash
  curl -u "elastic:$PASS" -k -X PUT "https://localhost:9200/test-index"
  ```
- [ ] **Document Indexing**: Can add a document.
  ```bash
  curl -u "elastic:$PASS" -k -X POST "https://localhost:9200/test-index/_doc/" -H 'Content-Type: application/json' -d'{"message": "hello world"}'
  ```
- [ ] **Search**: Can search for the document.
  ```bash
  curl -u "elastic:$PASS" -k "https://localhost:9200/test-index/_search?q=hello"
  ```

## 4. Operational Validation
- [ ] **Password Retrieval**: Can retrieve `elastic` user password from secret.
- [ ] **Restart Test**: Rolling restart completes without downtime.
- [ ] **Persistence Test**: Data persists after pod restart.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall elasticsearch -n monitoring`
- [ ] **PVC Cleanup**: PVCs deleted (if required).
