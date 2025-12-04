# ClickHouse POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `clickhouse` namespace exists.
- [ ] **Helm Repo Added**: Bitnami repo added.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: ClickHouse and Zookeeper pods are `Running`.
- [ ] **PVCs Bound**: Persistent Volume Claims are `Bound`.

## 3. Functional Testing
- [ ] **Connection**: Can connect via `clickhouse-client` or HTTP interface.
- [ ] **Cluster Info**: `system.clusters` shows correct shards and replicas.
- [ ] **Table Creation**: Can create a `MergeTree` or `ReplicatedMergeTree` table.
- [ ] **Data Ingestion**: Can INSERT data into the table.
- [ ] **Query Execution**: Can SELECT and aggregate data.

## 4. Operational Validation
- [ ] **Replication**: Data inserted on one replica is visible on another (if using ReplicatedMergeTree).
- [ ] **Resilience**: Cluster remains available if one pod is restarted.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall clickhouse -n clickhouse` executed.
- [ ] **PVC Cleanup**: PVCs deleted.
