# Istio Service Mesh on Kubernetes

> **Description:** Open platform to connect, manage, and secure microservices.
> **Version:** 1.20.0 (Example)

---

## 🏗️ Architecture

- **Control Plane (Istiod):** Manages configuration, discovery, and certificate issuance.
- **Data Plane (Envoy Proxies):** Sidecar proxies injected into application pods to intercept and manage traffic.
- **Ingress Gateway:** Entry point for external traffic.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.25+
- `istioctl` CLI installed (Recommended) or Helm 3+

---

## 🚀 Installation

### Option 1: Using `istioctl` (Recommended)

1. **Install CLI:**
   ```bash
   curl -L https://istio.io/downloadIstio | sh -
   cd istio-1.20.0
   export PATH=$PWD/bin:$PATH
   ```

2. **Install Istio (Demo Profile):**
   ```bash
   istioctl install --set profile=demo -y
   ```
   *Note: Use `profile=default` for production.*

### Option 2: Using Helm

1. **Add Repo:**
   ```bash
   helm repo add istio https://istio-release.storage.googleapis.com/charts
   helm repo update
   ```

2. **Install Base:**
   ```bash
   helm install istio-base istio/base -n istio-system --create-namespace
   ```

3. **Install Discovery (Istiod):**
   ```bash
   helm install istiod istio/istiod -n istio-system
   ```

4. **Install Ingress Gateway:**
   ```bash
   helm install istio-ingressgateway istio/gateway -n istio-system
   ```

---

## ⚙️ Configuration

### Enable Sidecar Injection
Label the namespace where you want sidecars injected automatically:
```bash
kubectl label namespace default istio-injection=enabled
```

### Gateway Configuration
Create a `Gateway` resource to allow traffic:
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: my-gateway
  namespace: default
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
```

---

## 💻 Usage

### Traffic Shifting (Canary)
Split traffic between two versions (v1 and v2):
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: my-service
spec:
  hosts:
  - my-service
  http:
  - route:
    - destination:
        host: my-service
        subset: v1
      weight: 90
    - destination:
        host: my-service
        subset: v2
      weight: 10
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n istio-system
```

### 2. Verify Injection
Deploy a sample app and check if it has 2 containers (App + Sidecar):
```bash
kubectl get pods -n default
# Should show READY 2/2
```

---

## 🧹 Maintenance

### Uninstall
```bash
istioctl uninstall --purge -y
kubectl delete namespace istio-system
```
