# Kafbat UI on Kubernetes

> **Description:** Web UI for managing Kafka clusters (Topics, Consumers, Schema Registry).
> **Note:** Kafbat UI is a community fork of Kafka UI.

---

## 🏗️ Architecture

- **Web UI:** Provides a visual interface for Kafka operations.
- **Backend:** Connects to Kafka brokers, Schema Registry, and Kafka Connect.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.20+
- Helm 3+
- A running Kafka cluster.

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add kafbat https://kafbat.github.io/helm-charts
helm repo update
```

### 2. Install Kafbat UI
```bash
helm upgrade --install kafbat-ui kafbat/kafka-ui \
  --namespace kafka \
  --values values.yaml \
  --version 1.5.3
```

---

## ⚙️ Configuration

The `values.yaml` file configures the connection to your Kafka cluster.

### Key Configuration (SASL/SCRAM)
To connect to a Kafka cluster secured with SASL/SCRAM, you need to provide the credentials in the `yamlApplicationConfig`.

```yaml
yamlApplicationConfig:
  kafka:
    clusters:
      - name: kafka-cluster-poc
        bootstrapServers: kafka-cluster-poc-3-9-1-kafka-bootstrap:9092
        properties:
          security.protocol: SASL_PLAINTEXT
          sasl.mechanism: SCRAM-SHA-512
          sasl.jaas.config: org.apache.kafka.common.security.scram.ScramLoginModule required username="admin" password="<PASSWORD>";
```

---

## 💻 Usage

### Access Web UI
Port-forward the service to access it locally:
```bash
kubectl port-forward svc/kafbat-ui-kafka-ui 8080:80 -n kafka
```
Open [http://localhost:8080](http://localhost:8080).

---

## 🧹 Cleanup

```bash
helm uninstall kafbat-ui -n kafka
```
