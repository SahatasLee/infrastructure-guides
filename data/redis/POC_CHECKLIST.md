# Redis POC Checklist

## Phase 1: Infrastructure

- [ ] **Operator Status**: Redis Operator pod is `Running`.
- [ ] **Cluster Status**: Redis Leader and Follower pods are `Running`.
    ```bash
    kubectl get rediscluster -n redis
    # State: Ready
    ```

## Phase 2: Functional Testing

- [ ] **Connection**:
    - [ ] Connect via `redis-cli` using the password from Secret.
    - [ ] `AUTH <password>` succeeds.
- [ ] **Data Operations**:
    - [ ] `SET mykey "hello"` -> OK.
    - [ ] `GET mykey` -> "hello".
- [ ] **Persistence**:
    - [ ] Restart Leader pod.
    - [ ] `GET mykey` -> "hello".

## Phase 3: Operations

- [ ] **Failover**:
    - [ ] Delete Leader pod.
    - [ ] Verify a Follower is promoted to Leader.
    - [ ] Cluster remains available.
