# Performance Test: Kafka Cluster 3.9.1

This guide details how to benchmark the Kafka 3.9.1 cluster.

## 1. Cluster Specifications

| Component | Details |
|-----------|---------|
| **Version** | 3.9.1 |
| **Brokers** | 3 |
| **Resources (per broker)** | CPU: 1 (req) / 2 (lim), RAM: 1Gi (req) / 4Gi (lim) |
| **Storage** | 10Gi per broker |
| **Internal Listener** | `kafka-cluster-poc-3-9-1-kafka-bootstrap:9092` (SASL_PLAINTEXT / SCRAM-SHA-512) |
| **Broker/Log Config** | `default.replication.factor: 3`, `min.insync.replicas: 3` |

## 2. Prerequisites

We will run the performance tests from a dedicated Pod within the Kubernetes cluster to minimize network latency implications from outside the cluster.

### 2.1 Deploy the Test Pod & Topic

Apply the testing topic and pod manifest:

```bash
kubectl apply -f perf-test-topic.yaml -n kafka
kubectl apply -f perf-test-pod.yaml -n kafka
```

Wait for the pod to be ready:

```bash
kubectl wait --for=condition=Ready pod/kafka-perf-test -n kafka
```

### 2.2 Prepare Configuration

Exec into the pod:

```bash
kubectl exec -it kafka-perf-test -n kafka -- bash
```

Create a `client.properties` file for authentication (Replace `<PASSWORD>` with the actual password for user `admin`):

> **Note**: You need to retrieve the password for the `admin` user from the Kubernetes Secret `admin`.
> command: `kubectl get secret admin -o jsonpath='{.data.password}' | base64 -d`

```bash
cat <<EOF > /tmp/client.properties
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="admin" password="<PASSWORD>";
EOF
```

## 3. Performance Test Scenarios

### 3.1 Producer Throughput

Test the write performance of the cluster.

**Variables:**
- `record-size`: Size of each message in bytes (e.g., 1024 for 1KB).
- `throughput`: Target throughput (records/sec). Set to `-1` for max effort.
- `num-records`: Total number of records to send.

**Command:**

```bash
/opt/kafka/bin/kafka-producer-perf-test.sh \
  --topic perf-test-topic-01 \
  --num-records 1000000 \
  --record-size 1024 \
  --throughput -1 \
  --producer.config /tmp/client.properties \
  --producer-props bootstrap.servers=kafka-cluster-poc-3-9-1-kafka-bootstrap:9092 acks=all
```

> **Note**: `acks=all` ensures highest durability, matching `min.insync.replicas=3`. For lower latency at cost of durability, use `acks=1`.

### 3.2 End-to-End Latency

Measure the time taken from producing a record to consuming it.

**Command:**

```bash
/opt/kafka/bin/kafka-run-class.sh kafka.tools.EndToEndLatency \
  kafka-cluster-poc-3-9-1-kafka-bootstrap:9092 \
  perf-test-topic-01 \
  10000 \
  1 \
  1024 \
  /tmp/client.properties
```

*(Args: Broker, Topic, NumRecords, ProducerAcks, RecordSize, ClientConfig)*

### 3.3 Consumer Throughput

Test the read performance. Ensure the topic has data first (run the producer test).

**Command:**

```bash
/opt/kafka/bin/kafka-consumer-perf-test.sh \
  --broker-list kafka-cluster-poc-3-9-1-kafka-bootstrap:9092 \
  --topic perf-test-topic-01 \
  --messages 1000000 \
  --consumer.config /tmp/client.properties \
  --group test-group \
  --print-metrics
```

> **Important**: The `admin` user ACL restricts access to group `test-group`. Ensure you use this group ID.

  --group test-group \
  --print-metrics
```

## 4. Stress Testing (Finding Limits)

To find the breaking point of the cluster, you successfully identified the baseline. Now push it further:

### 4.1 Maximize Throughput (Parallel Clients)
A single pod often hits its own CPU/Network limit before the Kafka cluster does. To saturate the brokers:

1.  **Scale the Test Pods:**
    Run multiple producer pods in parallel.
    ```bash
    kubectl scale pod kafka-perf-test --replicas=3
    ```
    *(Note: You might need to change the pod manifest to a Deployment to scale it)*

2.  **Run Simultaneous Tests:**
    Open multiple terminals, exec into each pod, and run the **Producer Throughput** command at the same time.

3.  **Calculate Total:** Sum the MB/s from all clients.

### 4.2 Vary Message Sizes
Network packet overhead matters.
-   **Small Messages (100 bytes):** Tests CPU and Request Handler efficiency (IOPS intensive).
-   **Large Messages (100KB - 1MB):** Tests Network Bandwidth and Disk Throughput.

### 4.3 What to Watch For (Saturation Indicators)
The cluster is "at limit" when:
1.  **Latency Spikes:** Average latency jumps from ~1s to 5-10s+.
2.  **Broker CPU:** Hits 80-90%.
3.  **Disk I/O Wait:** Metrics show high I/O wait time.
4.  **Error Rate:** You start seeing `TimeoutException` or `NotLeaderOrFollower` (due to overloaded brokers causing disconnects).

## 5. Cleanup

After testing, remove the pod and the test topic.

```bash
kubectl delete pod kafka-perf-test
kubectl delete kafka-topic perf-test-topic-01
```
