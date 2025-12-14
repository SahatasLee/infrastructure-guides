# Kafka Producer Acks Guide

This guide explains the `acks` configuration for Kafka Producers, which controls the durability and latency trade-offs for your messages.

## What are Producer Acks?

The `acks` (acknowledgments) setting determines how many partition replicas must receive a record before the producer considers the write successful. This setting directly impacts data durability and producer latency.

### `acks=0` (Fire and Forget)

- **Behavior**: The producer sends the message and considers it sent successfully immediately. It does not wait for any acknowledgment from the broker.
- **Durability**: Lowest. If the broker fails before writing the message to disk, the message is lost.
- **Latency**: Lowest. No network round-trip for acknowledgment.
- **Throughput**: Highest.
- **Use Case**: Logging, metrics, or data where some loss is acceptable.

### `acks=1` (Leader Acknowledgment)

- **Behavior**: The producer waits for the **Leader** replica to write the record to its local log. The leader responds with success without waiting for followers.
- **Durability**: Medium. If the leader fails immediately after acknowledging but before followers replicate, the record is lost.
- **Latency**: Medium. Waits for one broker.
- **Throughput**: High.
- **Use Case**: General-purpose messaging where a balance between safety and speed is needed.

### `acks=all` (All ISR Acknowledgment)

- **Behavior**: The producer waits for the **Leader** and **all in-sync replicas (ISR)** to acknowledge the record.
- **Durability**: Highest. Guarantees that the record will not be lost as long as at least one in-sync replica remains alive.
- **Latency**: Highest. Waits for multiple brokers.
- **Throughput**: Lower (bounded by the slowest replica).
- **Use Case**: Critical financial transactions, audit logs, or data that cannot be lost.
- **Configuration Note**: This should be used in conjunction with `min.insync.replicas` on the broker/topic level to be truly effective (e.g., `min.insync.replicas=2`).

---

## Configuring in Go (Sarama)

The provided Go example supports configuring acks via the `KAFKA_PRODUCER_ACKS` environment variable.

### Environment Variable

| Variable | Value | Equivalent `acks` | Sarama Constant |
| :--- | :--- | :--- | :--- |
| `KAFKA_PRODUCER_ACKS` | `0` | `acks=0` | `sarama.NoResponse` |
| `KAFKA_PRODUCER_ACKS` | `1` | `acks=1` | `sarama.WaitForLocal` |
| `KAFKA_PRODUCER_ACKS` | `all` (default) | `acks=all` | `sarama.WaitForAll` |

### Running the Example

**1. Default (Implicit `acks=all`)**
```bash
go run main.go
```

**2. Leader Only (`acks=1`)**
```bash
KAFKA_PRODUCER_ACKS=1 go run main.go
```

**3. Fire and Forget (`acks=0`)**
```bash
KAFKA_PRODUCER_ACKS=0 go run main.go
```
*Note: When using `acks=0`, the producer does not receive response metadata (partition/offset), so the logs will indicate the message was "sent" but without specific offset information.*
