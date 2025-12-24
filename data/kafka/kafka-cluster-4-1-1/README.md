# Kafka Cluster 4.1.1

> **Cluster Name:** `kafka-cluster-4-1-1`
> **Kafka Version:** 4.1.1
> **Strimzi Version:** v0.47.0+

## 🏗️ Cluster Specifications

### Brokers
- **Replicas:** 3
- **Resources:**
    - **CPU:** 1 (Request) / 2 (Limit)
    - **Memory:** 1Gi (Request) / 4Gi (Limit)
- **Storage:** 10Gi Persistent Volume (JBOD) per broker.
- **Storage Class:** `vks-storage-policy-latebinding`

### Controller
- **Replicas:** 3
- **Resources:**
    - **CPU:** 1 (Request) / 2 (Limit)
    - **Memory:** 1Gi (Request) / 4Gi (Limit)
- **Storage:** 10Gi Persistent Volume (JBOD) per broker.
- **Storage Class:** `vks-storage-policy-latebinding`

---

## 🚀 Installation

### Prerequisites
- Kubernetes Cluster v1.33+
- [Strimzi Operator v0.49.1+](https://strimzi.io/downloads/) installed.

### Steps

### Strimzi Operator Installation

```bash
# 1. Add Helm Repo
helm repo add strimzi https://strimzi.io/charts/
helm repo update

# 2. Create Namespace
kubectl create ns kafka

# 3. Install Operator
helm upgrade --install strimzi-kafka-operator strimzi/strimzi-kafka-operator \
  --version 0.49.1 \
  -n kafka \
  --set watchAnyNamespace=true
```

### KRaft Mode (No Zookeeper)

1. **Apply Configuration**
   ```bash
   kubectl apply -f kafka-node-pool.yaml -n kafka
   kubectl apply -f kafka-cluster.yaml -n kafka
   ```

2. **Verify Deployment**
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
kubectl get secret admin -n kafka -o jsonpath='{.data.password}' | base64 -d ; echo
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

```bash
kubectl apply -f pod-monitor.yaml -n kafka
```

### Verify Targets

Check your Prometheus dashboard under **Status -> Targets**. You should see targets named:
- `podMonitor/kafka/cluster-operator-metrics/0`
- `podMonitor/kafka/entity-operator-metrics/0`
- `podMonitor/kafka/kafka-resources-metrics/0`
