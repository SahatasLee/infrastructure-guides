# Apache Kafka (Strimzi Operator)

> **Description:** Enterprise-grade Kafka on Kubernetes using the Strimzi Operator. Supports KRaft mode.
> **Version:** Strimzi v0.38.x (Kafka v3.6+)
> **Last Updated:** 2025-12-04

## 📋 Prerequisites

List requirements before installation:
- [ ] Kubernetes Cluster v1.23+
- [ ] Helm v3+

---

## 🏗️ Architecture

Strimzi uses the **Operator Pattern**. You install the Operator first, then create a `Kafka` Custom Resource (CR) to deploy the cluster.

```mermaid
graph TD;
    Operator[Strimzi Operator] -->|Watch| CR[Kafka CR];
    CR -->|Reconcile| StatefulSet[Kafka StatefulSet];
    StatefulSet -->|Pod| Broker1;
    StatefulSet -->|Pod| Broker2;
    StatefulSet -->|Pod| Broker3;
```

---

## 🧠 หลักการทำงานของ Kafka (Working Principles)

Kafka เป็น Event Streaming Platform ที่ทำงานแบบ Distributed System โดยมีองค์ประกอบหลักดังนี้:

### 1. Core Concepts
- **Topic**: ช่องทางสำหรับจัดเก็บข้อมูล (เหมือน Table ใน Database หรือ Folder ใน Filesystem)
- **Partition**: การแบ่งข้อมูลใน Topic ออกเป็นส่วนๆ เพื่อให้สามารถ Scale ได้ (Parallel Processing)
- **Offset**: ตัวเลขระบุตำแหน่งของข้อมูลใน Partition (Unique ID)
- **Producer**: ผู้ส่งข้อมูลเข้าสู่ Kafka Topic
- **Consumer**: ผู้ดึงข้อมูลจาก Kafka Topic ไปใช้งาน
- **Consumer Group**: กลุ่มของ Consumer ที่ช่วยกันดึงข้อมูลจาก Topic เดียวกัน (1 Partition จะถูกอ่านโดย 1 Consumer ใน Group เท่านั้น)

### 2. Architecture Components
- **Broker**: Server ที่ทำหน้าที่รัน Kafka และจัดเก็บข้อมูล
- **Cluster**: กลุ่มของ Broker ที่ทำงานร่วมกัน
- **Zookeeper / KRaft**: ระบบจัดการ Metadata และ Leader Election (KRaft คือโหมดใหม่ที่ไม่ต้องใช้ Zookeeper)

---

## 🛡️ การป้องกันข้อมูลสูญหาย (Data Loss Prevention)

เพื่อให้มั่นใจว่าข้อมูลจะไม่สูญหาย (Zero Data Loss) ต้องตั้งค่าทั้งฝั่ง Broker และ Producer ดังนี้:

### 1. Broker Configuration (Server Side)
- **`replication.factor`**: ควรกำหนดเป็น `3` เพื่อให้มีสำเนาข้อมูล 3 ชุด
- **`min.insync.replicas`**: ควรกำหนดเป็น `2` เพื่อบังคับว่าข้อมูลต้องถูกเขียนลง Disk อย่างน้อย 2 เครื่องถึงจะถือว่าสำเร็จ
- **`unclean.leader.election.enable`**: ต้องเป็น `false` เพื่อป้องกันไม่ให้ Replica ที่ข้อมูลไม่ครบขึ้นมาเป็น Leader

### 2. Producer Configuration (Client Side)
- **`acks`**: ค่าที่แนะนำคือ `all` (หรือ `-1`) แต่มีตัวเลือกทั้งหมดดังนี้:
    - **`acks=0` (No Wait / Fire and Forget)**: Producer ส่งข้อมูลแล้วไม่รอการยืนยันใดๆ เร็วที่สุดแต่เสี่ยงข้อมูลหายมากที่สุด
    - **`acks=1` (Leader Only)**: Producer รอแค่ Leader เขียนลง Disk สำเร็จ ไม่รอ Follower (Default เก่า) ข้อมูลอาจหายถ้า Leader ล่มก่อน Replicate
    - **`acks=all` หรือ `-1` (Leader + ISR)**: **(แนะนำ)** Producer จะรอการยืนยันจาก Broker ก็ต่อเมื่อข้อมูลถูกเขียนลง Leader และ Follower Replicas ครบตามจำนวนที่กำหนดใน `min.insync.replicas` แล้วเท่านั้น มั่นใจได้สูงสุดว่าข้อมูลจะไม่หาย
- **`retries`**: ตั้งค่าให้สูง (เช่น `MAX_INT` หรือ `2147483647`)
    - **คำอธิบาย**: หากการส่งข้อมูลล้มเหลวด้วยสาเหตุชั่วคราว (เช่น Network กระตุก, กำลังเปลี่ยน Leader) Producer จะพยายามส่งข้อมูลใหม่ให้เองโดยอัตโนมัติ
    - **ผลลัพธ์**: ลดโอกาสที่ Application จะต้องจัดการ Error เอง และช่วยให้ข้อมูลส่งถึงปลายทางได้ในที่สุด
- **`enable.idempotence`**: ตั้งเป็น `true`
    - **คำอธิบาย**: เปิดใช้งาน Idempotent Producer ซึ่งจะมีการแนบ Sequence Number ไปกับข้อความ
    - **ผลลัพธ์**:
        1. **ป้องกันข้อมูลซ้ำ (No Duplicates):** หาก Producer Retry ส่งข้อมูลเดิม Broker จะรู้ว่าเป็นข้อมูลซ้ำและไม่บันทึกซ้อน
        2. **รักษาลำดับ (Guaranteed Ordering):** มั่นใจว่าข้อมูลจะถูกบันทึกตามลำดับที่ส่ง แม้จะมีการ Retry (ถ้าไม่เปิด อาจเกิดกรณีข้อมูลใหม่แซงข้อมูลเก่าที่กำลัง Retry)

---

## 🚀 Installation Guide

### 1. Install Strimzi Operator

```bash
# 1. Add Helm Repo
helm repo add strimzi https://strimzi.io/charts/
helm repo update

# 2. Create Namespace
kubectl create ns kafka

# 3. Install Operator
helm upgrade --install strimzi-kafka-operator strimzi/strimzi-kafka-operator \
  -n kafka \
  --set watchAnyNamespace=true
```

### 2. Deploy Kafka Cluster

Apply the Custom Resource definition to create the cluster.

```bash
kubectl apply -f kafka.yaml -n kafka
```

---

## ⚙️ Additional Resources

- **[Best Practices](./best-practices)**: Configuration and usage tips.
- **[Examples](./examples)**: Client examples in Go, Python, etc.
- **[Kafdrop](./kafdrop)**: Web UI for Kafka.
- **[Kafbat UI](./kafbat-ui)**: Modern Web UI for Kafka (Fork of Kafka UI).

---

## ⚙️ Configuration Details

**Key Configurations** (kafka.yaml)

| Parameter | Description | Default | Recommended |
| :--- | :--- | :--- | :--- |
| `spec.kafka.replicas` | Number of brokers | `3` | `3` |
| `spec.kafka.storage` | Storage type | `jbod` | `jbod` (Persistent) |
| `spec.kafka.listeners` | Listeners (Plain, TLS, External) | `plain, tls` | `plain, tls` |
| `spec.entityOperator` | User/Topic Operator | `enabled` | `enabled` |

---

## ✅ Verification & Usage

### 1. Check Status
```bash
kubectl get kafka -n kafka
# Wait for READY: True
```

### 2. Produce/Consume
```bash
# Start a producer
kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.38.0-kafka-3.6.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic

# Start a consumer
kubectl -n kafka run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.38.0-kafka-3.6.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --from-beginning
```

---

## 🔧 Maintenance & Operations

- **Upgrading**: Upgrade the Operator Helm chart first. Strimzi handles the rolling update of brokers.
- **Scaling**: Edit `kafka.yaml` -> change `replicas` -> `kubectl apply`.

---

## 📊 Monitoring & Alerts

- **Metrics**: Strimzi supports Prometheus via the `metricsConfig` in the CR.

---

## ❓ Troubleshooting

Common issues and fixes:

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| CrashLoopBackOff | OOM or Storage | Check PVC and Resources |
| Operator not reconciling | RBAC issues | Check Operator logs |

---

## 📚 References

- [Strimzi Documentation](https://strimzi.io/docs/operators/latest/full/deploying.html)
