# Kafka 4.1.1 KRaft POC Checklist

## Environment
- [X] **Kubernetes**: v1.32.8
- [X] **Strimzi**: v0.49.1
- [X] **Storage**: vks-storage-policy-latebinding

## 1. 🏗️ Infrastructure Deployment
- [X] 1.1 **Strimzi Operator**: Ensure v0.49.1 is running.
- [X] 1.2 **KRaft Cluster**:
    - [X] 1.2.1 `Kafka` resource applied.
    - [X] 1.2.2 `KafkaNodePool` (controller) applied & ready (3/3).
    - [X] 1.2.3 `KafkaNodePool` (broker) applied & ready (3/3).
    - [ ] 1.2.4 Check logs for "Transitioning to active" (Controller).
- [X] 1.3 **Storage**: Verify PVCs are bound for all brokers and controllers.

## 2. 🔌 Connectivity & Security
- [X] 2.1 **Internal Access** (port 9092):
    - [X] 2.1.1 Test connection from a pod in the same namespace. `kubectl -n <namespace> run netcat-test --image=busybox --restart=Never --rm -it -- nc -v -z <bootstrap-service-name> 9092`
- [X] 2.2 **External Access** (port 9094):
    - [X] 2.2.1 Verify LoadBalancer IP assignment.
    - [X] 2.2.2 Test `nc -v <LB-IP> 9094`.
- [X] 2.3 **Authentication**:
    - [X] 2.3.1 Create `KafkaUser` (SCRAM-SHA-512).
    - [X] 2.3.2 Authenticate successfully with client. `kubectl -n kafka run kafka-auth-test --image=quay.io/strimzi/kafka:0.49.1-kafka-4.1.1 --restart=Never -- sleep 3600`

## 3. ✅ Functional Testing
- [X] 3.1 **Topic Management**:
    - [X] 3.1.1 Create `my-topic` (3 partitions, 3 replicas).
    - [X] 3.1.2 Verify `min.insync.replicas` enforcement.
- [X] 3.2 **Produce/Consume**:
    - [X] 3.2.1 Produce 10,000 messages.
    - [X] 3.2.2 Consume all messages (lag should be 0).
- [X] 3.3 **Performance Baseline**:
    - [X] 3.3.1 Run `kafka-producer-perf-test` (Target: >10MB/s per broker). -> Result: 34.71 MB/s

## 4. 🛡️ Resilience (Day 2 Operations)
- [ ] 4.1 **Broker Failure**:
    - [ ] 4.1.1 Delete a **Broker** pod (`kubectl delete pod ...`).
    - [ ] 4.1.2 Verify Producer doesn't stop (acks=all).
    - [ ] 4.1.3 Verify Pod restarts and rejoins ISR.
- [ ] 4.2 **Controller Failure**:
    - [ ] 4.2.1 Delete active **Controller** pod.
    - [ ] 4.2.2 Verify new leader election (check logs/metrics).
- [ ] 4.3 **Rolling Updates**:
    - [ ] 4.3.1 Change a config (e.g., `log.retention.bytes`) in `Kafka`.
    - [ ] 4.3.2 Verify rolling restart occurs without downtime.

## 5. 🧩 Integrations
- [ ] 5.1 **Kafka Connect**:
    - [ ] 5.1.1 Deploy Connect cluster.
    - [ ] 5.1.2 Deploy a dummy Sink Connector (FileSink).
- [X] 5.2 **Cruise Control**:
    - [X] 5.2.1 Verify Cruise Control pod is running.
    - [ ] 5.2.2 (Optional) Trigger a rebalance proposal.

## 6. 📊 Observability
- [X] 6.1 **Prometheus**: Targets are UP.
- [X] 6.2 **Grafana**:
    - [X] 6.2.1 Kafka Overview Dashboard works.
    - [X] 6.2.2 Controller/KRaft specific metrics visible.

## 📝 Documentation

### 1. 🏗️ Infrastructure Deployment

- 1.1 **Strimzi Operator**: Ensure v0.49.1 is running.

```sh
# Check pod status
kubectl -n kafka get po
```

- 1.2 **KRaft Cluster**:
    - 1.2.1 `Kafka` resource applied.
    - 1.2.2 `KafkaNodePool` (controller) applied & ready (3/3).
    - 1.2.3 `KafkaNodePool` (broker) applied & ready (3/3).
    - 1.2.4 Check logs for "Transitioning to active" (Controller).
- 1.3 **Storage**: Verify PVCs are bound for all brokers and controllers.

### 2. 🔌 Connectivity & Security

### 3. ✅ Functional Testing

### 4. 🛡️ Resilience (Day 2 Operations)

### 5. 🧩 Integrations

### 6. 📊 Observability