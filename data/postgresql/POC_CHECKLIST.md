# PostgreSQL POC Checklist

## Phase 1: Infrastructure

- [ ] **Operator Status**: CNPG Operator pod is `Running`.
- [ ] **Cluster Status**: Primary and Standby pods are `Running`.
    ```bash
    kubectl cnpg status my-cluster -n postgres
    # Status: Cluster in healthy state
    ```

## Phase 2: Functional Testing

- [ ] **Connection**:
    - [ ] Connect via `psql` using the `app` user and password.
- [ ] **CRUD Operations**:
    - [ ] Create Table: `CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT);`
    - [ ] Insert: `INSERT INTO users (name) VALUES ('Alice');`
    - [ ] Select: `SELECT * FROM users;`

## Phase 3: Operations

- [ ] **Replication**:
    - [ ] Insert data on Primary.
    - [ ] Connect to Standby (read-only service).
    - [ ] Verify data exists.
- [ ] **Failover**:
    - [ ] Delete Primary pod.
    - [ ] Verify Standby is promoted.
    - [ ] Write capability restored.
