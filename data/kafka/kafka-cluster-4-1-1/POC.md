# Kafka 4.1.1 KRaft POC Checklist

## Environment
- [X] **Kubernetes**: v1.32.8
- [X] **Strimzi**: v0.49.1
- [X] **Storage**: vks-storage-policy-latebinding

## 1. 🏗️ Infrastructure Deployment
- [X] **Strimzi Operator**: Ensure v0.49.1+ is running.
- [X] **KRaft Cluster**:
    - [X] `Kafka` resource applied.
    - [X] `KafkaNodePool` (controller) applied & ready (3/3).
    - [X] `KafkaNodePool` (broker) applied & ready (3/3).
    - [] Check logs for "Transitioning to active" (Controller).
- [X] **Storage**: Verify PVCs are bound for all brokers and controllers.

## 2. 🔌 Connectivity & Security
- [ ] **Internal Access** (port 9092):
    - [ ] Test connection from a pod in the same namespace.
- [ ] **External Access** (port 9094):
    - [ ] Verify LoadBalancer IP assignment.
    - [ ] Test `openssl s_client -connect <LB-IP>:9094`.
- [ ] **Authentication**:
    - [X] Create `KafkaUser` (SCRAM-SHA-512).
    - [ ] Authenticate successfully with client.

## 3. ✅ Functional Testing
- [ ] **Topic Management**:
    - [X] Create `my-topic` (3 partitions, 3 replicas).
    - [ ] Verify `min.insync.replicas` enforcement.
- [ ] **Produce/Consume**:
    - [ ] Produce 10,000 messages.
    - [ ] Consume all messages (lag should be 0).
- [ ] **Performance Baseline**:
    - [ ] Run `kafka-producer-perf-test` (Target: >10MB/s per broker).

## 4. 🛡️ Resilience (Day 2 Operations)
- [ ] **Broker Failure**:
    - [ ] Delete a **Broker** pod (`kubectl delete pod ...`).
    - [ ] Verify Producer doesn't stop (acks=all).
    - [ ] Verify Pod restarts and rejoins ISR.
- [ ] **Controller Failure**:
    - [ ] Delete active **Controller** pod.
    - [ ] Verify new leader election (check logs/metrics).
- [ ] **Rolling Updates**:
    - [ ] Change a config (e.g., `log.retention.bytes`) in `Kafka`.
    - [ ] Verify rolling restart occurs without downtime.

## 5. 🧩 Integrations
- [ ] **Kafka Connect**:
    - [ ] Deploy Connect cluster.
    - [ ] Deploy a dummy Sink Connector (FileSink).
- [ ] **Cruise Control**:
    - [ ] Verify Cruise Control pod is running.
    - [ ] (Optional) Trigger a rebalance proposal.

## 6. 📊 Observability
- [ ] **Prometheus**: Targets are UP.
- [ ] **Grafana**:
    - [ ] Kafka Overview Dashboard works.
    - [ ] Controller/KRaft specific metrics visible.
