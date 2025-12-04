# Kafka POC Checklist

## Phase 1: Infrastructure

- [ ] **Operator Status**: Strimzi Operator pod is `Running`.
- [ ] **Cluster Status**: Kafka and Zookeeper (if used) pods are `Running`.
    ```bash
    kubectl get kafka -n kafka
    # READY: True
    ```

## Phase 2: Functional Testing

- [ ] **Topic Creation**:
    - [ ] Create a `KafkaTopic` CR.
    - [ ] Verify topic exists: `kubectl get kafkatopic`.
- [ ] **Produce/Consume**:
    - [ ] Start Producer: `kubectl run ... kafka-console-producer.sh ...`
    - [ ] Start Consumer: `kubectl run ... kafka-console-consumer.sh ...`
    - [ ] Verify message delivery.
- [ ] **Persistence**:
    - [ ] Restart a Broker pod.
    - [ ] Verify messages are still consumable.

## Phase 3: Operations

- [ ] **Scaling**:
    - [ ] Edit `kafka.yaml` -> Increase replicas.
    - [ ] Verify new broker joins the cluster.
