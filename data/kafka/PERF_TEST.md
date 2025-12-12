# Performance Test

- [ ] Throughput Capacity (Max MB/s)
- [ ] End-to-End Latency
- [ ] Scalability (Vertical & Horizontal)
- [ ] Resiliency / Chaos Testing

## Testing Scenarios

### 1. Throughput Capacity (Max MB/s)

- เป้าหมาย: หาจุดตันของระบบ (Bottleneck)

- วิธี: เพิ่ม throughput ไปเรื่อยๆ หรือเพิ่มจำนวน Producer Pods (Parallelism) จนกว่ากราฟ Write Latency จะเริ่มพุ่งสูงขึ้น หรือ Disk I/O เริ่มตัน

- Metrics ที่ต้องดู: Broker CPU, Disk IOPS, Network Bandwidth

### 2. End-to-End Latency

- เป้าหมาย: ดูว่า Message ส่งไปถึง Consumer เร็วแค่ไหน

- วิธี: ใช้ Producer ส่ง load คงที่ (เช่น 1000 msg/sec) แล้ววัดเวลาที่ Consumer ได้รับ

- Tools: อาจต้องใช้ k6 (xk6-kafka extension) หรือ Sangrenel เพื่อวัด Latency ได้ละเอียดกว่า script built-in

### 3. Scalability (Vertical & Horizontal)

- เป้าหมาย: ดูว่าการเพิ่ม Resource ช่วยได้จริงไหม

- Scenario:

    - ลองเพิ่ม Partitions จาก 3 -> 6 แล้วยิง Load เท่าเดิม ดูว่า Throughput ดีขึ้นไหม

    - ลองเพิ่ม Broker Pods (Scale out Strimzi)

### 4. Resiliency / Chaos Testing

- เป้าหมาย: ดูว่าถ้า Pod ตาย Cluster พังไหม? ข้อมูลหายไหม?

- Scenario:

    - รัน Producer load ทิ้งไว้ต่อเนื่อง

    - สั่ง kubectl delete pod my-cluster-kafka-0 (ฆ่า Broker ตัวหนึ่ง)

- สิ่งที่ต้องเช็ค:

    - Producer หยุดส่ง error หรือไม่? (ถ้า config acks=all และ min.insync.replicas ถูกต้อง ควรจะสะดุดนิดเดียวแล้วไปต่อได้)

    - มี Data Loss หรือไม่?

    - Consumer Group Rebalance นานไหม?

## Tools

### 1. Built-in Tools

- ใช้ Built-in scripts (kafka-producer-perf-test.sh) ยิงจาก Pod ภายใน Cluster

### 2. k6 (ร่วมกับ xk6-kafka):

- เขียน script เป็น JavaScript

- เหมาะกับ DevOps ยุคใหม่ Integrate กับ CI/CD ได้ง่าย

- สามารถ export ผลไปที่ Prometheus/Grafana ได้

### 3. Strimzi Kafka Benchmark:

- ทางทีม Strimzi มี repo แยกสำหรับ benchmark โดยเฉพาะ (ใช้ Ansible + OpenMessaging Benchmark) แต่อาจจะ setup ยากหน่อย

- Github: strimzi/strimzi-kafka-benchmark

### 4. OpenMessaging Benchmark:

- มาตรฐานอุตสาหกรรม (ที่ Confluent ใช้เทส) เหมาะสำหรับการเทสโหดๆ เพื่อจูน Kafka Config
