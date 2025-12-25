# Testing

เพื่อจัดการ Checklist ส่วนที่ 3 นี้ เราจำเป็นต้องใช้เครื่องมือ Command Line ของ Kafka (`kafka-topics.sh`, `kafka-producer-perf-test.sh`, etc.) ครับ

ผมแนะนำให้ **Remote เข้าไปใน Pod ชั่วคราว** ที่เราเคยสร้างไว้ (หรือสร้างใหม่) เพื่อรันคำสั่งเหล่านี้ เพราะจะง่ายกว่าการพิมพ์ `kubectl exec` ยาวๆ ทุกครั้งครับ

**ขั้นตอนเตรียมตัว (One-time setup):**

1. สร้าง Pod เครื่องมือ (ถ้ายังไม่มี):
```bash
kubectl run kafka-toolbox --image=quay.io/strimzi/kafka:latest-kafka-4.1.1-yaml --restart=Never -- sleep 3600

```


2. สร้างไฟล์ `client.properties` ใน Pod (สำหรับ Login):
```bash
kubectl exec -it kafka-toolbox -- bash
# เมื่อเข้ามาแล้ว ให้สร้างไฟล์ config (แก้ username/password ตามจริง)
cat <<EOF > client.properties
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="my-user" password="MyP@ssw0rd";
EOF

```



---

### ✅ 3.1.2 Verify `min.insync.replicas` enforcement

หัวข้อนี้คือการตรวจสอบว่า Topic ของเราถูกตั้งค่าให้ "ต้องการ Replicas ขั้นต่ำ" จริงหรือไม่ เพื่อป้องกันข้อมูลหาย

**วิธีตรวจสอบ:**
ใช้คำสั่ง Describe Topic เพื่อดู Config `min.insync.replicas`

```bash
bin/kafka-topics.sh --bootstrap-server <bootstrap-service>:9092 \
  --command-config client.properties \
  --describe --topic my-topic

```

**สิ่งที่ต้องดูในผลลัพธ์:**
มองหาคำว่า `Configs: min.insync.replicas=2` (หรือค่าที่คุณตั้งไว้)

* ถ้าเห็นค่านี้แสดงว่า **ผ่าน** (Config ถูก apply แล้ว)
* *Advanced Test:* ถ้าอยากเทส "Enforcement" (การบังคับใช้) จริงๆ คุณต้องลองปิด Broker ให้เหลือจำนวนน้อยกว่าค่านี้ แล้วลองส่งข้อมูลแบบ `acks=all` มันจะต้องฟ้อง Error ว่า `NOT_ENOUGH_REPLICAS` ครับ

---

### ✅ 3.2.1 Produce 10,000 messages

เราจะใช้เครื่องมือ `kafka-producer-perf-test` เพื่อยิงข้อมูลจำนวน 10,000 ข้อความเข้าไปอย่างรวดเร็วครับ

**คำสั่ง:**

```bash
bin/kafka-producer-perf-test.sh \
  --topic my-topic \
  --num-records 10000 \
  --record-size 100 \
  --throughput -1 \
  --producer-props bootstrap.servers=<bootstrap-service>:9092 acks=all \
  --producer.config client.properties

```

**สิ่งที่ต้องดู:**

* รอจนมันรันจบ และขึ้นสรุปว่าส่งไป 10000 records โดยไม่มี Error

---

### ✅ 3.2.2 Consume all messages (lag should be 0)

เราจะใช้ Consumer Group เพื่ออ่านข้อมูลทั้งหมด แล้วเช็คว่าอ่านครบไหม (Lag เป็น 0)

**ขั้นตอน 1: อ่านข้อมูลให้หมด (Drain Topic)**

```bash
bin/kafka-console-consumer.sh --bootstrap-server <bootstrap-service>:9092 \
  --topic my-topic \
  --consumer.config client.properties \
  --group checklist-group \
  --from-beginning --timeout-ms 10000

```

*(มันจะอ่านข้อความรัวๆ ขึ้นมา พออ่านหมดและไม่มีอะไรใหม่มา 10 วินาที มันจะหยุดเอง)*

**ขั้นตอน 2: เช็ค Lag (Verify)**

```bash
bin/kafka-consumer-groups.sh --bootstrap-server <bootstrap-service>:9092 \
  --command-config client.properties \
  --describe --group checklist-group

```

**สิ่งที่ต้องดูในตาราง:**

* คอลัมน์ **`LAG`** ของทุก Partition ต้องเป็น **`0`**
* คอลัมน์ `CURRENT-OFFSET` ต้องเท่ากับ `LOG-END-OFFSET`

---

### ✅ 3.3.1 Performance Baseline (>10MB/s per broker)

ข้อนี้คือการทำ Stress Test เพื่อวัดความเร็วสูงสุด (Throughput) ครับ

**สูตรคำนวณ:** 10MB/s ถ้าส่งข้อความขนาด 1KB (1024 bytes) จะต้องได้ประมาณ **10,000 records/sec**

**คำสั่งทดสอบ (ยิง 500,000 ข้อความ ขนาด 1KB):**

```bash
bin/kafka-producer-perf-test.sh \
  --topic my-topic \
  --num-records 500000 \
  --record-size 1024 \
  --throughput -1 \
  --producer-props bootstrap.servers=<bootstrap-service>:9092 acks=1 \
  --producer.config client.properties

```

**สิ่งที่ต้องดูในผลลัพธ์:**
ดูบรรทัดสุดท้ายที่สรุปผล:

> `500000 records sent, ... 15.42 MB/sec ...`

* ถ้าค่า **MB/sec** มากกว่า **10** -> **ผ่าน** ✅
* *(หมายเหตุ: ถ้า Cluster คุณมี 3 Broker ค่านี้คือค่ารวมของ Cluster ถ้าได้เกิน 30MB/s ยิ่งดีครับ)*