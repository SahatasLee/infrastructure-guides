# Emissary-Ingress on Kubernetes

> **Description:** Envoy-based API Gateway and Ingress Controller (formerly Ambassador).
> **Version:** 3.9.1 (Example)

---

## 🏗️ Architecture

- **Envoy Proxy:** The data plane handling traffic.
- **Control Plane:** Translates CRDs (Mappings, Hosts) into Envoy configuration.
- **CRDs:** `Mapping`, `Host`, `Listener` define routing and behavior.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.20+
- Helm 3+

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add datawire https://app.getambassador.io
helm repo update
```

### 2. Install Emissary-Ingress
```bash
helm upgrade --install emissary-ingress datawire/emissary-ingress \
  --namespace emissary \
  --create-namespace \
  --values values.yaml \
  --version 8.9.1
```

### 3. Wait for Deployment
```bash
kubectl rollout status deployment/emissary-ingress -n emissary -w
```

---

## ⚙️ Configuration

### 1. Define a Listener
Emissary requires a `Listener` to accept traffic.

```yaml
apiVersion: getambassador.io/v3alpha1
kind: Listener
metadata:
  name: emissary-ingress-listener-8080
  namespace: emissary
spec:
  port: 8080
  protocol: HTTP
  securityModel: XFP
  hostBinding:
    namespace:
      from: ALL
```

### 2. Define a Host
```yaml
apiVersion: getambassador.io/v3alpha1
kind: Host
metadata:
  name: wildcard-host
  namespace: emissary
spec:
  hostname: "*"
  acmeProvider:
    authority: none
```

Apply these configurations:
```bash
kubectl apply -f listener.yaml
kubectl apply -f host.yaml
```

---

## 💻 Usage

### Create a Mapping
Route traffic to a service.

```yaml
apiVersion: getambassador.io/v3alpha1
kind: Mapping
metadata:
  name: quote-backend
  namespace: default
spec:
  hostname: "*"
  prefix: /backend/
  service: quote:80
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n emissary
```

### 2. Verify Routing
```bash
curl http://<EXTERNAL-IP>/backend/
```

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade emissary-ingress datawire/emissary-ingress -n emissary --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall emissary-ingress -n emissary
```
