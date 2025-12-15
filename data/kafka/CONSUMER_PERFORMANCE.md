# Kafka Consumer Performance Guide

Optimizing Kafka consumer performance involves balancing throughput, latency, and resource utilization. This guide outlines key strategies and best practices.

## 1. Parallelism & Concurrency

The most effective way to scale consumption is through parallelism.

### Partitions & Consumer Groups
- **Rule of Thumb**: You cannot have more active consumers in a group than there are partitions in the topic. Extra consumers will sit idle.
- **Scaling**: To increase throughput, increase the number of partitions and add more consumer instances (pods/processes).

### Intra-Consumer Concurrency (Worker Pools)
If you cannot increase partitions or if your processing logic is slow (e.g., external API calls, DB writes), use a **Worker Pool** within a single consumer instance.
- **How it works**: The main consumer loop fetches messages and dispatches them to a channel. A pool of worker goroutines consumes from this channel and processes messages in parallel.
- **Benefit**: Decouples fetching from processing. High throughput even with few partitions.
- **Warning**: Message ordering is guaranteed *per partition* only up to the dispatch point. Parallel workers processing messages from the same partition *may* finish out of order. If strict ordering is required, you must route messages to workers based on Key (e.g., all messages for UserID X go to Worker 1), or process strictly sequentially.

## 2. Tuning Fetch Configuration

Adjust how much data the broker returns in each request to reduce network overhead.

- **`fetch.min.bytes`**: Minimum amount of data the server should return. If not enough data is available, it waits. increasing this improves throughput at the cost of latency.
- **`fetch.wait.max.ms`**: Maximum time the server will block before answering the fetch request if there isn't sufficient data to satisfy `fetch.min.bytes`.
- **`max.partition.fetch.bytes`**: The maximum amount of data per-partition the server will return. Increase this if you have large messages.

## 3. Commit Strategies

- **Auto-Commit (`enable.auto.commit`=true)**: Easiest. Fast. Risk of reprocessing small batches if crash occurs.
- **Manual Commit**:
    - **Synchronous**: Safe but slow. Blocks until commit is confirmed.
    - **Asynchronous**: Fast but harder to handle failures.
    - **Batch Commit**: Process a batch of N messages, then commit the latest offset. Best balance.

## 4. Rebalance Listener

Implement `Setup` and `Cleanup` in your `ConsumerGroupHandler`.
- **Setup**: Initialize resources (db connections, etc.).
- **Cleanup**: Flush buffers, commit pending offsets. Crucial for "Exctly-Once" or "At-Least-Once" semnatics to avoid duplicates after rebalance.

## Best Practice Example Pattern (Go)

The best general-purpose pattern for high-throughput generic processing (where strict ordering isn't a hard blocker or can be managed downstream) is the **Worker Pool**.

See the `examples/golang/consume/main.go` for the implementation.
