# Debezium on Kubernetes (Strimzi)

> **Description:** Guide to deploying Debezium as a Kafka Connect cluster using Strimzi Operator.
> **Last Updated:** 2025-12-17

## 📋 Overview

การใช้งาน Debezium บน Kubernetes ผ่าน Strimzi มีขั้นตอนหลักๆ คือ:
1. **Build Kafka Connect Image**: สร้าง Docker Image ที่มี Kafka Connect และ Debezium Plugins
2. **Deploy Kafka Connect**: สร้าง `KafkaConnect` CR ที่ใช้ Image ที่เราสร้าง
3. **Create Connector**: สร้าง `KafkaConnector` CR เพื่อเริ่มดึงข้อมูล

---

## 🛠️ Step 1: Build Custom Image

Debezium เป็นเพียง Plugin (JAR files) ที่ต้องนำไปใส่ใน Kafka Connect ดังนั้นเราต้องสร้าง Docker Image ขึ้นมาใหม่

**Dockerfile:**
```dockerfile
FROM quay.io/strimzi/kafka:0.38.0-kafka-3.6.0
USER root:root
RUN mkdir -p /opt/kafka/plugins/debezium
COPY ./plugins/ /opt/kafka/plugins/debezium/
USER 1001
```

*หมายเหตุ: คุณต้องไป download Debezium connector plugin (zip) จาก [Debezium Website](https://debezium.io/releases/) มาแตกไฟล์ใส่ folder `plugins` หรือใช้วิธี Download ใน Dockerfile เลยก็ได้*

**Alternative Dockerfile (Download Direct):**
```dockerfile
FROM quay.io/strimzi/kafka:0.38.0-kafka-3.6.0
USER root:root
RUN microdnf install -y curl tar gzip && \
    mkdir -p /opt/kafka/plugins/debezium && \
    curl -L https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.5.0.Final/debezium-connector-postgres-2.5.0.Final-plugin.tar.gz | tar -xz -C /opt/kafka/plugins/debezium
USER 1001
```

build และ push ไปยัง Registry ของคุณ:
```bash
docker build -t my-registry/kafka-connect-debezium:latest .
docker push my-registry/kafka-connect-debezium:latest
```

---

## 🚀 Step 2: Deploy Kafka Connect

สร้างไฟล์ `kafka-connect.yaml`:

```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaConnect
metadata:
  name: my-connect-cluster
  namespace: kafka
  annotations:
    strimzi.io/use-connector-resources: "true" # เปิดให้สร้าง Connector ผ่าน CR ได้
spec:
  version: 3.6.0
  replicas: 1
  bootstrapServers: my-cluster-kafka-bootstrap:9092
  image: my-registry/kafka-connect-debezium:latest # Image ที่เรา Build
  config:
    group.id: connect-cluster
    offset.storage.topic: connect-cluster-offsets
    config.storage.topic: connect-cluster-configs
    status.storage.topic: connect-cluster-status
    # ... converters configs
    key.converter: org.apache.kafka.connect.json.JsonConverter
    value.converter: org.apache.kafka.connect.json.JsonConverter
    key.converter.schemas.enable: false
    value.converter.schemas.enable: false
```

---

## 🔌 Step 3: Create Connector

ใช้ Custom Resource `KafkaConnector` แทนการยิง API เอง:

### PostgreSQL
รายละเอียดใน `connector.yaml`

### MySQL
ดูตัวอย่างใน `connector-mysql.yaml`

### SQL Server
ดูตัวอย่างใน `connector-sqlserver.yaml`

**สำคัญ:** อย่าลืมเปลี่ยนค่า connection config (hostname, user, password) ให้ตรงกับ Database ของคุณ

---

## ✅ Verification

```bash
# Check Kafka Connect Status
kubectl get kafkaconnect -n kafka

# Check Connector Status
kubectl get kafkaconnector -n kafka
```
