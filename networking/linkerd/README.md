# Linkerd on Kubernetes

> **Description:** Ultralight, security-first Service Mesh.
> **Version:** Stable-2.14.0 (Example)

---

## 🏗️ Architecture

- **Control Plane:** Manages the mesh configuration and identity.
- **Data Plane:** Lightweight micro-proxies running as sidecars.
- **Viz (Optional):** Dashboard and metrics (Prometheus/Grafana).

---

## 📋 Prerequisites

- Kubernetes Cluster 1.21+
- `linkerd` CLI installed (Recommended) or Helm 3+

---

## 🚀 Installation

### Option 1: Using `linkerd` CLI (Recommended)

1. **Install CLI:**
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://run.linkerd.io/install | sh
   export PATH=$PATH:$HOME/.linkerd2/bin
   ```

2. **Validate Cluster:**
   ```bash
   linkerd check --pre
   ```

3. **Install CRDs:**
   ```bash
   linkerd install --crds | kubectl apply -f -
   ```

4. **Install Control Plane:**
   ```bash
   linkerd install | kubectl apply -f -
   ```

5. **Verify Installation:**
   ```bash
   linkerd check
   ```

6. **Install Viz (Dashboard):**
   ```bash
   linkerd viz install | kubectl apply -f -
   linkerd check
   ```

### Option 2: Using Helm

1. **Add Repo:**
   ```bash
   helm repo add linkerd https://helm.linkerd.io/stable
   helm repo update
   ```

2. **Install CRDs:**
   ```bash
   helm install linkerd-crds linkerd/linkerd-crds -n linkerd --create-namespace
   ```

3. **Install Control Plane:**
   *Note: Requires valid issuer certificates for mTLS.*
   ```bash
   helm install linkerd-control-plane linkerd/linkerd-control-plane \
     -n linkerd \
     --set-file identityTrustAnchorsPEM=ca.crt \
     --set-file identity.issuer.tls.crtPEM=issuer.crt \
     --set-file identity.issuer.tls.keyPEM=issuer.key
   ```

---

## ⚙️ Configuration

### Automatic Injection
Annotate the namespace to automatically inject sidecars:

```bash
kubectl annotate namespace default linkerd.io/inject=enabled
```

### High Availability (HA)
For production, use the HA mode (replicas=3):

```bash
linkerd install --ha | kubectl apply -f -
```

---

## 💻 Usage

### Access Dashboard
```bash
linkerd viz dashboard
```
Opens `http://localhost:50750`.

### View Traffic (CLI)
See live traffic metrics for a deployment:
```bash
linkerd viz top deployment/my-app
```

### Tap Traffic (CLI)
See live request stream:
```bash
linkerd viz tap deployment/my-app
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n linkerd
kubectl get pods -n linkerd-viz
```

### 2. Verify mTLS
```bash
linkerd viz edges deployment -n default
# Should show 'Secured' column as 100%
```

---

## 🧹 Maintenance

### Uninstall
```bash
linkerd viz uninstall | kubectl delete -f -
linkerd uninstall | kubectl delete -f -
```
