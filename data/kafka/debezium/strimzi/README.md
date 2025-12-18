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


---

## 🧠 Deep Dive: How it works

ส่วนนี้จะอธิบายการทำงานของ Connector และความหมายของ Config ต่างๆ โดยละเอียด

### 1. The Configuration Explained

มาดูไส้ในของ `connector-psql.yaml` (หรือไฟล์อื่นๆ) กันครับ:

```yaml
spec:
  class: io.debezium.connector.postgresql.PostgresConnector 
  tasksMax: 1
  config:
    database.hostname: postgres-service  # IP หรือ Service Name ของ Database
    database.port: 5432
    database.user: postgres
    database.password: postgres
    database.dbname: postgres
    
    # 🎯 Topic Prefix: สำคัญมาก! ใช้เป็น prefix ของ Topic ที่จะถูกสร้าง
    topic.prefix: dbserver1
    
    # 📋 Table Whitelist: ระบุเฉพาะ Table ที่ต้องการ (Format: schema.table)
    table.include.list: public.customers
    
    # 🧩 Plugin Name: สำหรับ Postgres ต้องใช้ pgoutput (Built-in decoding logic)
    plugin.name: pgoutput
```

### 2. How Topics are Created (สำคัญ!)

Debezium จะ **สร้าง Kafka Topic ให้โดยอัตโนมัติ** สำหรับทุกๆ Table ที่เราไปดักจับ โดยใช้ Naming Convention ดังนี้:

> **Format:** `<topic.prefix>.<schema>.<table_name>`

**ตัวอย่าง:**
- `topic.prefix` = **dbserver1**
- schema = **public**
- table = **customers**

👉 Kafka Topic ที่เกิดขึ้นคือ: `dbserver1.public.customers`

### 3. Message Structure (Value)

เมื่อข้อมูลใน Database เปลี่ยนแปลง (Insert/Update/Delete) Debezium จะ Produce message ไปลง Topic
ข้อมูล (Value) จะเป็น JSON ที่มีโครงสร้างมาตรฐานดังนี้:

```json
{
  "schema": { ... }, 
  "payload": {
    "before": {           // ข้อมูล "ก่อน" การเปลี่ยนแปลง (จะเป็น null ถ้าเป็น INSERT)
      "id": 101,
      "email": "old@example.com"
    },
    "after": {            // ข้อมูล "หลัง" การเปลี่ยนแปลง (จะเป็น null ถ้าเป็น DELETE)
      "id": 101,
        "email": "new@example.com"
    },
    "source": { ... },    // 
    "op": "u",            // Operation type: c=create, u=update, d=delete, r=read (snapshot)
    "ts_ms": 1638345678   // timestamp
  }
}
```

### 4. สรุป Flow การทำงาน

1. **Connector Start:** Debezium เชื่อมต่อไปยัง Database
2. **Snapshot (Optional):** ถ้าเป็นครั้งแรก มันจะ Select ข้อมูลทั้งหมดมาแปลงเป็น Event (op=`r`)
3. **Stream:** หลังจากนั้นจะ Monitor Transaction Log (WAL)
4. **Produce:** เมื่อเจอ change -> สร้าง JSON -> ยิงลง Topic `prefix.schema.table`
5. **Consume:** ใช้ Kafka Consumer ดึงข้อมูลมาใช้

### 5. FAQ: สามารถสร้าง Topic เองได้ไหม? (Custom Topics)

**ทำได้ครับ!** และ **แนะนำให้ทำ** สำหรับ Production ด้วย

#### Scenario A: อยากกำหนด Config ของ Topic (Partitions, Retention)
Debezium จะสร้าง Topic ให้ Auto ก็จริง แต่มักจะเป็น Default Config (1 partition) ซึ่งอาจไม่พอ
**วิธีทำ:** สร้าง `KafkaTopic` CR รอไว้ก่อนเลย **โดยตั้งชื่อให้ตรงกับที่ Debezium จะใช้** (`prefix.schema.table`)

```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaTopic
metadata:
  name: dbserver1.public.customers  # <-- ชื่อต้องเป๊ะ!
  labels:
    strimzi.io/cluster: my-cluster
spec:
  partitions: 3          # กำหนด Partition เองได้
  replicas: 3
  config:
    retention.ms: 604800000  # 7 Days
    cleanup.policy: compact  # แนะนำสำหรับ CDC!
```

#### Scenario B: อยากเปลี่ยนชื่อ Topic ไปเลย (ไม่เอา prefix.schema.table)
ถ้าอยากให้ Topic ชื่อ `crm.users` แทนที่จะเป็น `dbserver1.public.customers`
**วิธีทำ:** ใช้ **SMT (Single Message Transform)** ชื่อ `ByLogicalTableRouter`

เพิ่ม Config นี้ลงใน `KafkaConnector`:

```yaml
config:
  # ... config เดิม ...
  
  # เปลี่ยนชื่อ Topic
  transforms: RerouteTopic
  transforms.RerouteTopic.type: io.debezium.transforms.ByLogicalTableRouter
  transforms.RerouteTopic.topic.regex: dbserver1.public.(.*)
  transforms.RerouteTopic.topic.replacement: crm.$1
```

แบบนี้ Topic ที่ออกมาจะเป็น `crm.customers` แทน
  
---

### 6. FAQ: ใช้กับ CloudNativePG (CNPG) ได้ไหม?

**ได้ครับ!** และเป็นท่าที่นิยมมากใน Kubernetes

สิ่งที่ต้องทำเพิ่มในฝั่ง **CNPG Cluster YAML**:

1. **เปิด WAL Level**: ต้องแก้ `postgresql.conf` ผ่าน `spec.postgresql`
2. **Connection**: ให้ชี้ไปที่ Service RW (`-rw`)

**ตัวอย่าง CNPG Cluster:**
```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: my-pg-cluster
spec:
  # ... options ...
  postgresql:
    parameters:
      wal_level: logical  # 👈 ต้องมีบรรทัดนี้!
      max_replication_slots: "10" 
```

**ตัวอย่าง Debezium Config:**
```yaml
config:
  database.hostname: my-pg-cluster-rw # 👈 ใช้ Service RW
  database.port: 5432
  database.user: streaming_replica    # หรือ user ที่มีสิทธิ์ replication
  # ...
