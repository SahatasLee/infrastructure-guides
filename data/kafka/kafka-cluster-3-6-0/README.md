# Kafka Cluster 3.6.0 (POC)

> **Cluster Name:** `kafka-cluster-poc-3-6-0`
> **Kafka Version:** 3.6.0
> **Strimzi Version:** v1beta2

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

## 🔌 Listeners & Networking

| Name | Port | Type | TLS | Authentication |
| :--- | :--- | :--- | :--- | :--- |
| `plain` | 9092 | Internal | `false` | SCRAM-SHA-512 |
| `external` | 9094 | LoadBalancer | `false` | SCRAM-SHA-512 |

**External Access (LoadBalancer IPs):**
- **Bootstrap:** `10.10.1.2`
- **Broker 0:** `10.10.1.3`
- **Broker 1:** `10.10.1.4`
- **Broker 2:** `10.10.1.5`

---

## ⚙️ Key Configurations

- **Replication Factor:** 3 (Default, Offsets, Transaction Log)
- **Min In-Sync Replicas:** 3
- **Log Message Format:** 3.6
- **Inter-Broker Protocol:** 3.6
- **Authorization:** Simple

---

## 📊 Monitoring

- **JMX Prometheus Exporter:** Enabled (ConfigMap: `kafka-metrics-config.yaml`)
- **Kafka Exporter:** Enabled
    - **Resources:** 100m/128Mi (Request) - 500m/512Mi (Limit)
    - **Liveness Probe:** 15s delay, 10s period
    - **Readiness Probe:** 15s delay, 10s period

---

## 🧩 Additional Components

- **Entity Operator:** Enabled (Topic & User Operator)
- **Cruise Control:** Enabled

---

## 🚀 Installation

### Prerequisites
- Kubernetes Cluster
- [Strimzi Operator](https://strimzi.io/docs/operators/latest/deploying.html) installed in the cluster.

### Steps

1. **Create Namespace** (Optional)
   If you haven't created the namespace yet:
   ```bash
   kubectl create ns kafka
   ```

2. **Apply Configuration**
   Deploy the Kafka cluster using the provided YAML file:
   ```bash
   kubectl apply -f kafka-cluster.yml -n kafka
   ```

3. **Verify Deployment**
   Wait for the pods to become ready:
   ```bash
   kubectl get pods -n kafka -w
   # Wait for kafka-cluster-poc-3-6-0-kafka-0, 1, 2 to be READY 1/1
   # Wait for kafka-cluster-poc-3-6-0-zookeeper-0, 1, 2 to be READY 1/1
   ```
