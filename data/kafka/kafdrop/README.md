# Kafdrop on Kubernetes

> **Description:** Web UI for viewing Kafka topics and browsing consumer groups.
> **Image:** `obsidiandynamics/kafdrop`

---

## 🚀 Installation

### 1. Configure Credentials (Optional)
If your Kafka cluster uses SASL/SCRAM, you need to provide the credentials in the `deployment.yaml` or via a Secret.

### 2. Apply Manifests
```bash
kubectl apply -f secret.yaml -n kafka
kubectl apply -f deployment.yaml -n kafka
kubectl apply -f service.yaml -n kafka
kubectl apply -f ingress.yaml -n kafka
```

---

## ⚙️ Configuration

The `deployment.yaml` is configured to connect to the Kafka cluster.

**Key Environment Variables:**

| Variable | Description | Default (in example) |
| :--- | :--- | :--- |
| `KAFKA_BROKERCONNECT` | Comma-separated list of brokers. | `kafka-cluster-poc-3-9-1-kafka-bootstrap:9092` |
| `KAFKA_PROPERTIES` | Base64 encoded properties file (for SASL). | *Configured for SCRAM-SHA-512* |
| `JVM_OPTS` | JVM options. | `-Xms32M -Xmx64M` |

---

## 💻 Usage

### Access Web UI
Port-forward the service to access it locally:
```bash
kubectl port-forward svc/kafdrop 9000:9000 -n kafka
```
Open [http://localhost:9000](http://localhost:9000).

---

## 🧹 Cleanup

```bash
kubectl delete -f deployment.yaml -n kafka
kubectl delete -f service.yaml -n kafka
```
