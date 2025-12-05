# Kafka Cluster 3.9.1

> **Cluster Name:** `kafka-cluster-poc-3-9-1`
> **Kafka Version:** 3.9.1
> **Strimzi Version:** v0.47.0+

## 🏗️ Cluster Specifications

### Brokers
- **Replicas:** 3
- **Resources:**
    - **CPU:** 1 (Request) / 4 (Limit)
    - **Memory:** 2Gi (Request) / 8Gi (Limit)
    - **JVM Heap:** 1GB (`-Xms: 1g`, `-Xmx: 1g`)
- **Storage:** 10Gi Persistent Volume (JBOD) per broker.
- **Storage Class:** `vks-storage-policy-latebinding`

### Zookeeper
- **Replicas:** 3
- **Resources:**
    - **CPU:** 1 (Request) / 2 (Limit)
    - **Memory:** 2Gi (Request) / 8Gi (Limit)
    - **JVM Heap:** 1GB (`-Xms: 1g`, `-Xmx: 1g`)
- **Storage:** 10Gi Persistent Volume per node.

---

## 🚀 Installation

### Prerequisites
- Kubernetes Cluster v1.33+
- [Strimzi Operator v0.47.0+](https://strimzi.io/downloads/) installed.

### Steps

### KRaft Mode (Zookeeper-less)

For a modern, Zookeeper-less deployment using KRaft:

1. **Apply the Node Pool and Cluster:**
   ```bash
   kubectl apply -f kafka-node-pool.yml
   kubectl apply -f kafka-cluster-kraft.yml
   ```

2. **Verify:**
   ```bash
   kubectl get kafkanodepool
   kubectl get kafka kafka-cluster-kraft
   ```
