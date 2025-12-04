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

1. **Create Namespace** (Optional)
   ```bash
   kubectl create ns kafka
   ```

2. **Apply Configuration**
   ```bash
   kubectl apply -f kafka-cluster.yml -n kafka
   ```

3. **Verify Deployment**
   ```bash
   kubectl get pods -n kafka -w
   ```
