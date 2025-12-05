# Traefik on Kubernetes

> **Description:** Modern HTTP reverse proxy and load balancer (Ingress Controller).
> **Version:** 2.10 (Example)

---

## 🏗️ Architecture

- **Ingress Controller:** Watches Kubernetes Ingress and IngressRoute resources.
- **EntryPoints:** Listeners for HTTP (80) and HTTPS (443).
- **Middleware:** Request tweaking (stripping prefixes, auth, rate limiting).

---

## 📋 Prerequisites

- Kubernetes Cluster 1.20+
- Helm 3+

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add traefik https://traefik.github.io/charts
helm repo update
```

### 2. Install Traefik
```bash
helm upgrade --install traefik traefik/traefik \
  --namespace traefik \
  --create-namespace \
  --values values.yaml \
  --version 24.0.0
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `ingressClass.enabled` | `true` | Register as an IngressClass. |
| `ports.web.nodePort` | `30080` | NodePort for HTTP (if using NodePort). |
| `ports.websecure.nodePort` | `30443` | NodePort for HTTPS. |
| `service.type` | `LoadBalancer` | Expose via LoadBalancer. |

---

## 💻 Usage

### 1. IngressRoute (CRD)
Traefik's custom resource for advanced routing.

```yaml
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: my-app
  namespace: default
spec:
  entryPoints:
    - web
  routes:
  - match: Host(`myapp.example.com`)
    kind: Rule
    services:
    - name: my-app-service
      port: 80
```

### 2. Standard Ingress
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    kubernetes.io/ingress.class: traefik
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-service
            port:
              number: 80
```

### 3. Dashboard Access
Port-forward to access the dashboard:
```bash
kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name -n traefik) 9000:9000 -n traefik
```
Open [http://localhost:9000/dashboard/](http://localhost:9000/dashboard/).

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n traefik
```

### 2. Verify Routing
Curl the endpoint with the Host header:
```bash
curl -H "Host: myapp.example.com" http://<EXTERNAL-IP>
```

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade traefik traefik/traefik -n traefik --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall traefik -n traefik
```
