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

### Zookeeper Mode (Legacy)

1. **Create Namespace** (Optional)
   ```bash
   kubectl create ns kafka
   ```

2. **Apply Configuration**
   ```bash
   kubectl apply -f kafka-cluster.yaml -n kafka
   ```

3. **Verify Deployment**
   ```bash
   kubectl get pods -n kafka -w
   ```

## 🔐 User Management

### Create User
Apply the `kafka-user.yaml` manifest:
```bash
kubectl apply -f kafka-user.yaml -n kafka
```

### Retrieve Password
The password is stored in a Kubernetes Secret named after the user (e.g., `admin`).

```bash
kubectl get secret admin -n kafka -o jsonpath='{.data.password}' | base64 ; echo
```

## Monitoring
 
Monitoring is handled via the Prometheus Operator using `PodMonitor` resources.
 
### Prerequisites
- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) or Prometheus Operator installed.
- Ensure your `PodMonitor` has the correct labels to be discovered by Prometheus (default: `release: kube-prometheus-stack`).
 
### Enable Monitoring
 
Apply the `pod-monitor.yaml` to create `PodMonitor` resources for:
- Cluster Operator
- Entity Operator (User/Topic)
- Kafka Brokers
- Zookeeper Nodes
 
```bash
kubectl apply -f pod-monitor.yaml -n kafka
```
 
### Verify Targets
 
Check your Prometheus dashboard under **Status -> Targets**. You should see targets named:
- `podMonitor/kafka/cluster-operator-metrics/0`
- `podMonitor/kafka/entity-operator-metrics/0`
- `podMonitor/kafka/kafka-resources-metrics/0`
