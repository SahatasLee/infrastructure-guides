# TiDB POC Checklist

## Phase 1: Infrastructure

- [ ] **Operator Status**: TiDB Operator pods are `Running`.
- [ ] **Cluster Status**: PD, TiKV, and TiDB pods are `Running`.
    ```bash
    kubectl get tidbcluster -n tidb-cluster
    # Ready: True
    ```

## Phase 2: Functional Testing

- [ ] **SQL Connection**:
    - [ ] Connect via MySQL client: `mysql -h <tidb-service-ip> -P 4000 -u root`.
    - [ ] Connection successful.
- [ ] **CRUD Operations**:
    - [ ] Create DB: `CREATE DATABASE test;`
    - [ ] Create Table: `CREATE TABLE t1 (id INT);`
    - [ ] Insert Data: `INSERT INTO t1 VALUES (1);`
    - [ ] Select Data: `SELECT * FROM t1;`

## Phase 3: Operations

- [ ] **Dashboard**: Access TiDB Dashboard via `http://<pd-service>:2379/dashboard`.
- [ ] **Grafana**: Verify TiDB metrics in Grafana.
