# Debezium with Kafka (Change Data Capture)

> **Description:** Guide to using Debezium for Change Data Capture (CDC) with Apache Kafka.
> **Version:** Debezium v2.x
> **Last Updated:** 2025-12-17

## 📖 Introduction

**Debezium** คือ Open Source Platform สำหรับทำ **Change Data Capture (CDC)** ซึ่งทำหน้าที่ "ดักจับ" การเปลี่ยนแปลงข้อมูล (Insert, Update, Delete) จาก Database (เช่น PostgreSQL, MySQL, SQL Server, MongoDB) และส่งข้อมูลการเปลี่ยนแปลงเหล่านั้นไปยัง **Apache Kafka** ในรูปแบบของ Event Stream แบบ Real-time

### Use Cases
- **Replication**: ส่งข้อมูลจาก Database หลักไปยัง Data Warehouse หรือ Search Engine (เช่น Elasticsearch)
- **Microservices**: ส่ง Event เมื่อมีการเปลี่ยนแปลงข้อมูล (Outbox Pattern)
- **Cache Invalidation**: อัปเดต Cache (Redis) ทันทีที่มีการแก้ข้อมูล
- **Auditing**: เก็บ History ของการเปลี่ยนแปลงข้อมูลทุก record

---

## 🏗️ Architecture

การทำงานของ Debezium จะรันอยู่บน **Kafka Connect** (Framework ของ Kafka สำหรับเชื่อมต่อกับ External Systems)

```mermaid
graph LR;
    App[Application] -->|Write| DB[(Source DB\nPostgreSQL)];
    DB -->|CDC Log| Debezium[Kafka Connect\n(Debezium Connector)];
    Debezium -->|Produce| Kafka[Apache Kafka];
    Kafka -->|Consume| Consumer[Consumers\n(Apps, Analytics)];
```

1. **Source DB**: ฐานข้อมูลต้นทาง (ต้องเปิด Mode CDC เช่น Write Ahead Log)
2. **Debezium**: ทำงานเป็น Connector plugin ใน Kafka Connect อ่าน Log ของ DB
3. **Kafka**: เก็บ Change Events ลงใน Topic (1 Table = 1 Topic)
4. **Consumer**: ปลายทางที่นำข้อมูลไปใช้

---

## 🚀 Quick Start (Docker Compose)

วิธีที่ง่ายที่สุดในการทดลองใช้ Debezium คือการรันผ่าน Docker Compose

### 1. Prerequisites
- Docker & Docker Compose

### 2. Prepare `docker-compose.yaml`

สร้างไฟล์ `docker-compose.yaml` เพื่อจำลองระบบทั้งหมด:
- Zookeeper & Kafka
- PostgreSQL (Source)
- Kafka Connect (Debezium)
- Kafdrop (Monitoring UI)

*(ดูไฟล์ตัวอย่างใน directory นี้)*

### 3. Start Services

```bash
docker-compose up -d
```

### 4. Register Connector

เมื่อระบบรันเสร็จแล้ว เราต้องบอกให้ Debezium เริ่มดักจับข้อมูลจาก Postgres โดยการส่ง API Request ไปที่ Kafka Connect

**Configuration (`connector.json`):**

```json
{
  "name": "inventory-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "tasks.max": "1",
    "database.hostname": "postgres",
    "database.port": "5432",
    "database.user": "postgres",
    "database.password": "postgres",
    "database.dbname": "postgres",
    "topic.prefix": "dbserver1",
    "table.include.list": "public.customers",
    "plugin.name": "pgoutput"
  }
}
```

**Register via cURL:**

```bash
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" \
  http://localhost:8083/connectors/ \
  -d @connector.json
```

---

## ✅ Verification

### 1. Check Connector Status

```bash
curl -s http://localhost:8083/connectors/inventory-connector/status
```

ต้องได้สถานะ `RUNNING` ทั้ง Connector และ Task

### 2. View Data in Kafka

เปิด Browser ไปที่ **Kafdrop** (http://localhost:9000) หรือใช้ command line ดู Topic ที่เกิดขึ้น
- จะเห็น Topic ชื่อ `dbserver1.public.customers` (Format: `prefix.schema.table`)
- ข้อมูลข้างในจะเป็น JSON ที่มี `before` (ค่าเก่า) และ `after` (ค่าใหม่)

### 3. Test Data Changes

ลอง Insert/Update ข้อมูลใน Postgres:

```bash
# Login to Postgres
docker-compose exec postgres psql -U postgres -d postgres

# SQL Commands
INSERT INTO customers (first_name, last_name, email) VALUES ('Sahatas', 'Lee', 'sahatas@example.com');
UPDATE customers SET email = 'new-email@example.com' WHERE first_name = 'Sahatas';
DELETE FROM customers WHERE first_name = 'Sahatas';
```

คุณจะเห็น Event ใหม่ๆ ไหลเข้า Kafka ทันที

---

## ⚙️ Configuration Hints

- **Snapshot Mode**: โดยปกติ Debezium จะทำการ "Snapshot" (ดึงข้อมูลทั้งหมดที่มีอยู่เดิม) ก่อนเริ่มทำงาน CDC
- **Tombstone Events**: เมื่อมีการ Delete ข้อมูล Debezium จะส่ง Event ที่มี value เป็น `null` ตามมาเพื่อให้ Kafka รู้ว่า key นี้ถูกลบแล้ว (สำหรับการทำ Log Compaction)
- **Postgres WAL Level**: ต้องตั้งค่า `wal_level = logical` ใน `postgresql.conf` เสมอ

## 📚 References
- [Debezium Documentation](https://debezium.io/documentation/reference/stable/)
- [Debezium Tutorial](https://debezium.io/documentation/reference/stable/tutorial.html)
