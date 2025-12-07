# Keycloak on Kubernetes

> **Description:** Open Source Identity and Access Management.
> **Version:** 22.0.0 (Example)

---

## 🏗️ Architecture

- **Keycloak Server:** Handles authentication and authorization.
- **PostgreSQL Database:** Stores realms, users, and clients.

---

## 📋 Prerequisites

- Kubernetes Cluster 1.23+
- Helm 3+
- Ingress Controller (e.g., NGINX)

---

## 🚀 Installation

### 1. Deploy Keycloak

```bash
kubectl apply -f keycloak.yaml -f postgresql.yaml
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `auth.adminUser` | `admin` | Admin username. |
| `postgresql.enabled` | `true` | Use internal PostgreSQL. |
| `ingress.enabled` | `true` | Expose via Ingress. |
| `ingress.hostname` | `auth.example.com` | Domain name. |
| `production` | `true` | Enable production mode (caching, etc.). |

---

## 💻 Usage

### Access Admin Console
Navigate to `https://auth.example.com`.
Login with `admin` / `admin-password`.

### Create Realm
1. Click **Master** (top left) -> **Create Realm**.
2. Name: `my-realm`.

### Create Client
1. Go to **Clients** -> **Create Client**.
2. Client ID: `my-app`.
3. Valid Redirect URIs: `https://myapp.example.com/*`.

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n keycloak
```

### 2. Check Logs
```bash
kubectl logs -f statefulset/keycloak -n keycloak
```

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade keycloak bitnami/keycloak -n keycloak --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall keycloak -n keycloak
```
