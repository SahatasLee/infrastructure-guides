# Vitess on Kubernetes

> **Description:** Database clustering system for horizontal scaling of MySQL.
> **Version:** 19.0.0 (Example)

---

## 🏗️ Architecture

- **VTGate:** Routes queries to the correct VTTablet.
- **VTTablet:** A proxy that sits in front of a MySQLd process.
- **VTctld:** Cluster management daemon.
- **Topology Service:** Stores configuration data (etcd, Zookeeper, or Consul).

---

## 📋 Prerequisites

- Kubernetes Cluster 1.24+
- `vtctlclient` and `mysql` client installed (Optional but recommended).
- Helm 3+

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add vitess https://vitess.io/helm/
helm repo update
```

### 2. Install Vitess Operator
```bash
helm upgrade --install vitess vitess/vitess-operator \
  --namespace vitess \
  --create-namespace \
  --values values.yaml \
  --version 2.10.0
```

### 3. Create a Vitess Cluster
Apply a `VitessCluster` Custom Resource (CR) to deploy the actual database cluster.

```yaml
# cluster.yaml
apiVersion: planetscale.com/v2
kind: VitessCluster
metadata:
  name: example
  namespace: vitess
spec:
  images:
    vtctld: vitess/lite:v19.0.0
    vtgate: vitess/lite:v19.0.0
    vttablet: vitess/lite:v19.0.0
    vtbackup: vitess/lite:v19.0.0
    mysqld: vitess/lite:v19.0.0
  cells:
  - name: zone1
    gateway:
      replicas: 2
      resources:
        requests:
          cpu: 500m
          memory: 1Gi
    keyspaces:
    - name: commerce
      shards:
      - name: "0"
        tablets:
        - type: replica
          replicas: 2
        - type: rdonly
          replicas: 1
      schema:
        initial: |-
          create table product (
            sku varbinary(128),
            description varbinary(128),
            price bigint,
            primary key(sku)
          );
```

```bash
kubectl apply -f cluster.yaml
```

---

## ⚙️ Configuration

### Sharding
To enable sharding, you define a VSchema.

1. **Connect to VTGate:**
   ```bash
   pf_port=$(kubectl get service example-zone1-vtgate-bn -n vitess -o jsonpath='{.spec.ports[0].port}')
   kubectl port-forward svc/example-zone1-vtgate-bn -n vitess $pf_port:$pf_port
   ```

2. **Apply VSchema:**
   Use `vtctlclient` to apply vschema that defines sharding keys.

---

## 💻 Usage

### Connect via MySQL Protocol
```bash
mysql -h 127.0.0.1 -P $pf_port
```

### Execute Queries
```sql
INSERT INTO product (sku, description, price) VALUES ('SKU-1001', 'Monitor', 100);
SELECT * FROM product;
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n vitess
```

### 2. Check Topology
Access VTctld dashboard:
```bash
kubectl port-forward deployment/vitess-operator 15999:15999 -n vitess
# (Note: VTctld usually runs as a separate service in the cluster, check svc)
kubectl port-forward svc/example-zone1-vtctld 15000:15000 -n vitess
```
Open `http://localhost:15000`.

---

## 🧹 Maintenance

### Uninstall
```bash
kubectl delete -f cluster.yaml
helm uninstall vitess -n vitess
```
