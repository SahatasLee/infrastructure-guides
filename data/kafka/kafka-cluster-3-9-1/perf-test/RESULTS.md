# Performance Test Results

## 1. Producer Throughput Test (Baseline)

**Configuration:**
- **Topic:** `perf-test-topic-01` (3 Partitions, 3 Replicas)
- **Message Size:** 1024 bytes (1KB)
- **Total Records:** 1,000,000
- **Acks:** `all` (Highest Durability - waits for all in-sync replicas)
- **Authentication:** SASL_PLAINTEXT / SCRAM-SHA-512

### Result Summary

| Metric | Value | Note |
|--------|-------|------|
| **Throughput (Records)** | **~26,878 records/sec** | consistent load |
| **Throughput (Data)** | **26.25 MB/sec** | |
| **Avg Latency** | **1072.39 ms** | ~1 second average |
| **99th % Latency** | **1939 ms** | 1% of requests took ~2 seconds |
| **Max Latency** | **2026 ms** | |

### Analysis

1.  **High Latency (~1s Avg):**
    - The average latency of ~1 second is primarily driven by the `acks=all` configuration combined with the cluster's underlying storage/network performance.
    - Since `min.insync.replicas=3` is likely enforced (or at least ineffective replication factor is 3), every write must be acknowledged by all 3 brokers before the producer gets a success response.
    - This confirms specific durability guarantees but highlights a trade-off with speed.

2.  **Throughput vs Latency:**
    - Despite the high latency per request, the system achieved a respectable throughput of **~26 MB/s**. This indicates the brokers are handling concurrent requests reasonably well, but individual request commit times are the bottleneck.

### Recommendations for Improvement (if needed)

- **For Lower Latency:** If the use case allows some risk of data loss (e.g., metrics, logs), switch to `acks=1`. This will likely reduce latency significantly (potentially to <100ms) and increase throughput.
- **For Higher Throughput:** Use more producer threads/instances or increase `batch.size` and `linger.ms` in the producer configuration to send data in larger chunks.

## 2. Consumer Throughput Test

**Configuration:**
- **Topic:** `perf-test-topic-01`
- **Group:** `test-group`
- **Messages:** 1,000,000

### Result Summary

| Metric | Value | Note |
|--------|-------|------|
| **Records Consumed Rate** | **~28,162 records/sec** | ~27.5 MB/s |
| **Max Fetch Latency** | **N/A** | Not shown in summary, but lag indicates healthy consumption |

### Analysis

- **Balanced Performance:** The consumer rate (~28k records/sec) matched the producer rate closely (~26k records/sec), indicating the system is well-balanced and not bottlenecked by consumption speed under this load.
- **Fetch Size:** The `records-per-request-avg` is ~1003, meaning the consumer is efficiently fetching batches of 1000 records at a time.

## 3. End-to-End Latency Test (ความหน่วงรวมระบบ)

**ผลลัพธ์ (Results):**

| Metric (หน่วยวัด) | Value (ค่าที่ได้) | ความหมาย |
|------------------|-------------------|----------|
| **Avg Latency** | **2.7292 ms** | ค่าเฉลี่ยความเร็วในการส่งและรับกลับอยู่ที่ประมาณ **2.7 มิลลิวินาที** (ถือว่าเร็วมาก) |
| **50th Percentile** | **1 ms** | ครึ่งหนึ่งของข้อมูลใช้เวลาเพียง **1 ms** |
| **99th Percentile** | **24 ms** | 99% ของข้อมูลใช้เวลาไม่เกิน **24 ms** |
| **99.9th Percentile** | **44 ms** | มีเพียงส่วนน้อยมาก (0.1%) ที่ช้ากว่า 44 ms |

### บทวิเคราะห์ (Analysis in Thai):

- **ประสิทธิภาพสูงมาก (High Performance):** ค่าเฉลี่ย Latency ที่ **2.7 ms** ถือว่ายอดเยี่ยมสำหรับการใช้งาน Real-time
- **ความเสถียร (Stability):** ค่า P99 ที่ 24ms แสดงว่าระบบมีความนิ่งพอสมควร อาจมีกระตุกบ้างเล็กน้อย (Jitter) แต่ยังอยู่ในเกณฑ์ดีเยี่ยมสำหรับการใช้งานทั่วไป
- **สรุปภาพรวม:** Cluster นี้พร้อมสำหรับการใช้งานที่ต้องการความไวสูง (Low Latency Workloads) ครับ

## 4. Stress Test Results (ทดสอบขีดจำกัด)

**Scenario:**
- **Clients:** 5 Concurrent Pods (Scaled Deployment)
- **Tool:** `stress-test.sh` (Auto-generated)
- **Target:** Max Cluster Throughput

**ผลลัพธ์ (Results):**

| Metric | Value (Total) | Note |
|--------|---------------|------|
| **Total Throughput** | **68.20 MB/s** | (Peak Load) |
| **Total Records/sec** | **~69,828 records/sec** | |
| **Per Pod Avg** | **~13.6 MB/s** | (ดรอปลงจาก 26 MB/s เมื่อรันตัวเดียว) |

### บทวิเคราะห์ (Analysis in Thai):

1.  **System Capacity:** ระบบสามารถรองรับได้สูงสุดประมาณ **68 MB/s** (เมื่อเพิ่ม Client เป็น 5 ตัว)
2.  **Bottleneck:**
    - เมื่อรัน 1 Pod ได้ **26 MB/s**
    - เมื่อรัน 5 Pods ได้ **68 MB/s** (เฉลี่ยเหลือตัวละ 13 MB/s)
    - **สรุป:** การเพิ่ม Client ช่วยเพิ่ม Total Throughput ได้จริง แต่ประสิทธิภาพต่อ Client เริ่มตกลง (Diminishing Returns) แสดงว่าเราเริ่มเข้าใกล้ขีดจำกัดของ Broker (เช่น Disk IOPS หรือ Network Bandwidth) ที่ประมาณ 70 MB/s ครับ

## 5. Breaking Point (จุดที่ระบบล่ม)

**Scenario:**
- **Clients:** 6 Concurrent Pods
- **Total Records:** 6,000,000 (1M per pod)

**ผลลัพธ์ (Critical Failure):**
- **Brokers Crashed:** Kafka Brokers ทั้ง 3 ตัว (broker-0, 1, 2) เข้าสู่สถานะ `CrashLoopBackOff`
- **Error Logs:** Client แจ้งเตือน `Connection disconnected` และ `TimeoutException`
- **Infrastructure:** Kubernetes Cluster ยังทำงานได้ แต่ Broker รับ Load ไม่ไหวจน Process ตาย

### สรุปขีดจำกัด (Final Conclusion):
1.  **Safe Limit:** รองรับได้ดีที่ **5 Clients** (Traffic ~70 MB/s)
2.  **Breaking Limit:** ระบบล่มเมื่อเจอ Load จาก **6 Clients** (Traffic พยายามดันทะลุ 75-80 MB/s)
3.  **Root Cause:** น่าจะเกิดจาก resource exhaustion (CPU/Memory/Disk IO) บนตัว Broker Pods ทำให้ Process Java ตาย
