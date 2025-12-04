# Kafka Best Practices & Examples

> **Description:** Practical examples and best practices for running Kafka in production.

---

## 🔧 Best Practices

### 1. Topic Naming Convention
Use a structured naming convention to keep topics organized.
**Format:** `<domain>.<entity>.<event>.<version>`
- **Example:** `payment.transaction.created.v1`
- **Example:** `user.account.updated.v2`

### 2. Partitioning Strategy
- **Throughput vs. Latency**: More partitions = higher throughput but higher latency (and more open files).
- **Key-based Ordering**: Messages with the same key go to the same partition. Use this to guarantee order for a specific entity (e.g., `user_id`).

### 3. Configuration Tuning
| Parameter | Component | Recommended | Reason |
| :--- | :--- | :--- | :--- |
| `compression.type` | Producer | `snappy` or `lz4` | Reduces network bandwidth and disk usage with low CPU overhead. |
| `batch.size` | Producer | `16384` (16KB) or higher | Increases throughput by sending more data in one request. |
| `linger.ms` | Producer | `5` - `10` ms | Adds a small delay to allow batching, significantly improving throughput. |
| `auto.offset.reset` | Consumer | `earliest` | Ensures no data is missed if the consumer group is new. |

---

## 💻 Usage Examples

### 1. CLI Commands (Strimzi)

**Create a Topic:**
```bash
kubectl -n kafka run kafka-topics -ti --image=quay.io/strimzi/kafka:0.38.0-kafka-3.6.0 --rm=true --restart=Never -- bin/kafka-topics.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --create --topic payment.transaction.created.v1 --partitions 3 --replication-factor 3
```

**List Topics:**
```bash
kubectl -n kafka run kafka-topics -ti --image=quay.io/strimzi/kafka:0.38.0-kafka-3.6.0 --rm=true --restart=Never -- bin/kafka-topics.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --list
```

**Describe Consumer Group:**
```bash
kubectl -n kafka run kafka-consumer-groups -ti --image=quay.io/strimzi/kafka:0.38.0-kafka-3.6.0 --rm=true --restart=Never -- bin/kafka-consumer-groups.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --describe --group my-group
```

### 2. Python Producer Example (High Reliability)

Using `confluent-kafka` library:

```python
from confluent_kafka import Producer
import socket

conf = {
    'bootstrap.servers': 'my-cluster-kafka-bootstrap:9092',
    'client.id': socket.gethostname(),
    'acks': 'all',              # Wait for all replicas
    'enable.idempotence': True, # Prevent duplicates
    'retries': 1000000,         # Retry indefinitely
    'linger.ms': 5,             # Batching delay
    'compression.type': 'lz4'   # Compression
}

producer = Producer(conf)

def acked(err, msg):
    if err is not None:
        print(f"Failed to deliver message: {err}")
    else:
        print(f"Message produced: {msg.topic()} [{msg.partition()}] @ {msg.offset()}")

# Produce message
producer.produce('payment.transaction.created.v1', key='user_123', value='{"amount": 100}', callback=acked)

# Flush
producer.flush()
```

---

## 📊 Monitoring Checklist

Alert on these critical metrics:
- [ ] **Consumer Lag**: `kafka_consumergroup_lag > 0` (Consumer is falling behind).
- [ ] **Under Replicated Partitions**: `kafka_server_replicamanager_underreplicatedpartitions > 0` (Data is at risk).
- [ ] **Offline Partitions**: `kafka_controller_kafkacontroller_offlinepartitionscount > 0` (Data is unavailable).
