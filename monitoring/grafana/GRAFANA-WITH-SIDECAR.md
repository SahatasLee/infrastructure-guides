# ทำ **Sidecar** ใน Grafana Helm Chart

การทำ **Sidecar** ใน Grafana Helm Chart คือเทคนิคที่ช่วยให้เรา **"เพิ่ม Datasource และ Dashboard โดยอัตโนมัติ"** ผ่าน Kubernetes ConfigMap หรือ Secret แทนที่จะต้องไปกด Add ในหน้าเว็บ UI ครับ

วิธีนี้เหมาะมากสำหรับการทำ **GitOps** (คือเก็บ Config ทุกอย่างเป็น Code) พอ Deploy ปุ๊บ กราฟมาครบ Database ต่อติดทันที

นี่คือขั้นตอนการทำครับ แบ่งเป็น 2 ส่วน:

-----

### 1\. ตั้งค่าใน `values.yaml` ก่อน (เปิดใช้งาน Sidecar)

ในไฟล์ `values.yaml` ของ Grafana Helm Chart คุณต้องไปเปิดฟีเจอร์นี้และกำหนด **"Label"** ที่ Sidecar จะคอยมองหาครับ

```yaml
# values.yaml

sidecar:
  dashboards:
    enabled: true
    label: grafana_dashboard    # (สำคัญ) ConfigMap ไหนที่มี Label นี้จะถูกดึงมาเป็น Dashboard
    searchNamespace: ALL        # มองหาในทุก Namespace หรือจะระบุเฉพาะก็ได้
    folderAnnotation: k8s-sidecar-target-directory # (Optional) ถ้าอยากระบุโฟลเดอร์ใน Grafana

  datasources:
    enabled: true
    label: grafana_datasource   # (สำคัญ) ConfigMap/Secret ไหนที่มี Label นี้จะถูกดึงมาเป็น Datasource
    searchNamespace: ALL
```

-----

### 2\. วิธีทำ Sidecar for Datasources (ต่อ Database อัตโนมัติ)

เมื่อเปิดใช้งานในข้อ 1 แล้ว ให้คุณสร้างไฟล์ Kubernetes Manifest (ConfigMap หรือ Secret) โดยต้องมี **Label** ตรงกับที่ตั้งไว้ (`grafana_datasource`)

**ตัวอย่างไฟล์ `my-datasource.yaml`:**

```yaml
apiVersion: v1
kind: Secret  # แนะนำใช้ Secret สำหรับ Password
metadata:
  name: grafana-datasource-postgres
  namespace: monitoring
  labels:
    grafana_datasource: "1"  # <--- ต้องมี Label นี้ (Value เป็นอะไรก็ได้ ขอแค่มี key ตรง)
type: Opaque
stringData:
  datasource.yaml: |-
    apiVersion: 1
    datasources:
    - name: PostgreSQL-Main
      type: postgres
      url: my-postgres-postgresql.database.svc.cluster.local:5432
      user: app_user
      secureJsonData:
        password: "YourAppPassword"
      jsonData:
        sslmode: "disable"
        database: "app_db"
```

*เมื่อ Apply ไฟล์นี้ Grafana จะเห็น Datasource ชื่อ "PostgreSQL-Main" โผล่ขึ้นมาเองครับ*

-----

### 3\. วิธีทำ Sidecar for Dashboards (โหลดกราฟอัตโนมัติ)

หลักการเดียวกันครับ สร้าง ConfigMap ที่เก็บ JSON ของ Dashboard และแปะ **Label** ให้ตรง (`grafana_dashboard`)

**ขั้นตอน:**

1.  สร้าง Dashboard ใน Grafana หรือไปโหลดจากเว็บ Grafana.com
2.  Export ออกมาเป็นไฟล์ **JSON**
3.  เอา JSON นั้นมายัดใส่ ConfigMap

**ตัวอย่างไฟล์ `my-dashboard.yaml`:**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-dashboard-node-exporter
  namespace: monitoring
  labels:
    grafana_dashboard: "1" # <--- ต้องมี Label นี้
    # k8s-sidecar-target-directory: "/General"  # (Optional) ถ้าอยากระบุโฟลเดอร์ให้ใช้ Annotation นี้
data:
  # ชื่อไฟล์ต้องลงท้ายด้วย .json
  node-exporter-full.json: |-
    {
      "annotations": {
        "list": [
          {
            "builtIn": 1,
            ... (เนื้อหา JSON ยาวๆ ที่ Export มาวางตรงนี้) ...
          }
        ]
      }
      ...
    }
```

-----

### สรุปหัวใจสำคัญ (Key Takeaways)

1.  **Label ต้องตรงกัน:** นี่คือจุดที่คนพลาดบ่อยที่สุด ชื่อ Label ใน `values.yaml` กับใน ConfigMap/Secret ต้องเหมือนกันเป๊ะๆ (เช่น `grafana_dashboard`)
2.  **Namespace:** โดย Default Sidecar มักจะหาแค่ใน Namespace เดียวกับที่ Grafana อยู่ ถ้าคุณแยก Namespace ต้องตั้ง `searchNamespace: ALL` หรือระบุให้ชัดเจน
3.  **Unique Name:** ใน ConfigMap หนึ่งอัน สามารถใส่ได้หลายไฟล์ JSON แต่ระวังชื่อไฟล์ซ้ำกันครับ

**Tip:** ถ้าขี้เกียจ Copy-Paste JSON ใส่ YAML ยาวๆ คุณสามารถใช้คำสั่ง `kubectl` สร้าง ConfigMap จากไฟล์ JSON ได้เลย แล้วค่อยมาแปะ Label ทีหลัง:

```bash
# 1. สร้าง ConfigMap จากไฟล์ JSON
kubectl create configmap my-dashboard --from-file=dashboard.json -n monitoring

# 2. แปะ Label ให้ Sidecar เห็น
kubectl label configmap my-dashboard grafana_dashboard=1 -n monitoring
```