# Kafka Cluster 3.7.0 (K8s 1.33 Compatible)

> **Cluster Name:** `kafka-cluster-poc-3-7-0`
> **Kafka Version:** 3.7.0
> **Strimzi Version:** v0.43.0+ (Required for K8s 1.33)

## ⚠️ Compatibility Note

**Why Kafka 3.7.0?**
- **Kubernetes 1.33** requires Strimzi Operator **v0.43.0** or newer (due to Fabric8 client compatibility).
- **Strimzi v0.43.0+** drops support for Kafka 3.6.x.
- Therefore, to run on K8s 1.33, you **MUST** use Kafka 3.7.0 or newer.

---

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
- [Strimzi Operator v0.43.0+](https://strimzi.io/downloads/) installed.

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
