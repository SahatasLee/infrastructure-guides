# MetalLB on Kubernetes

> **Description:** Bare metal load-balancer for Kubernetes.
> **Version:** 0.13.12 (Example)

---

## 🏗️ Architecture

- **Controller:** Allocates IPs to services.
- **Speaker:** Speaks routing protocols (ARP/NDP for Layer 2, BGP for Layer 3) to advertise IPs.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.20+
- Helm 3+
- A range of IP addresses available for the LoadBalancer.

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add metallb https://metallb.github.io/metallb
helm repo update
```

### 2. Install MetalLB
```bash
helm upgrade --install metallb metallb/metallb \
  --namespace metallb-system \
  --create-namespace \
  --values values.yaml \
  --version 0.13.12
```

---

## ⚙️ Configuration

After installation, you must configure the IP address pool using CRDs.

### 1. Define IP Address Pool
Create `ip-pool.yaml`:
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.240-192.168.1.250
```

### 2. Advertise the Pool (Layer 2)
Create `l2advertisement.yaml`:
```yaml
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
```

### 3. Apply Configuration
```bash
kubectl apply -f ip-pool.yaml
kubectl apply -f l2advertisement.yaml
```

---

## 💻 Usage

### Expose a Service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 80
  type: LoadBalancer
```

Check the external IP:
```bash
kubectl get svc my-service
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n metallb-system
# Should see controller and speaker pods
```

### 2. Check LoadBalancer IP
Deploy a test service and verify it gets an IP from the configured pool.

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade metallb metallb/metallb -n metallb-system --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall metallb -n metallb-system
```
