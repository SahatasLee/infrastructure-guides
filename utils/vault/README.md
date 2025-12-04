# HashiCorp Vault

> **Description:** Secure, store and tightly control access to tokens, passwords, certificates, encryption keys for protecting secrets and other sensitive data using a UI, CLI, or HTTP API.
> **Version:** Chart v0.28.0+ (Vault v1.16.x)
> **Last Updated:** 2025-12-04

## 📋 Prerequisites

List requirements before installation:

- [ ] Kubernetes Cluster v1.24+
- [ ] Minimum RAM: 4GB / CPU: 2 Cores (for HA cluster)
- [ ] Helm v3+
- [ ] Storage Class (Default or specific SC for Raft storage)

---

## 🏗️ Architecture

Vault is deployed in High Availability (HA) mode using Raft integrated storage.

```mermaid
graph TD;
    Client -->|Request| LB(Load Balancer/Ingress);
    LB --> VaultService[Vault Service];
    VaultService --> VaultPod1[Vault Pod 1 (Active)];
    VaultService --> VaultPod2[Vault Pod 2 (Standby)];
    VaultService --> VaultPod3[Vault Pod 3 (Standby)];
    VaultPod1 <-->|Raft| VaultPod2;
    VaultPod2 <-->|Raft| VaultPod3;
    VaultPod1 <-->|Raft| VaultPod3;
```

---

## 🚀 Installation Guide

### Option 1: Installation via Helm (Recommended)

```bash
# 1. Add Helm Repo
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

# 2. Create Namespace
kubectl create ns vault

# 3. Install/Upgrade
helm upgrade --install vault hashicorp/vault \
  -n vault \
  -f values.yaml
```

---

## ⚙️ Configuration Details

**Key Configurations** (values.yaml)

| Parameter | Description | Default | Recommended |
| :--- | :--- | :--- | :--- |
| `server.ha.enabled` | Enable High Availability | `false` | `true` |
| `server.ha.replicas` | Number of Vault replicas | `3` | `3` |
| `server.ha.raft.enabled` | Enable Raft storage | `true` | `true` |
| `server.resources.requests.memory` | Memory request | `256Mi` | `256Mi` |
| `server.dataStorage.size` | PVC size for Raft data | `10Gi` | `10Gi` |

---

## ✅ Verification & Usage

### 1. Initialize Vault
When Vault is installed with Raft, it starts uninitialized and sealed.

```bash
# Exec into one of the pods
kubectl exec -ti vault-0 -n vault -- sh

# Initialize Vault (Save the Unseal Keys and Root Token!)
vault operator init
```

### 2. Unseal Vault
You must unseal **each** pod (vault-0, vault-1, vault-2) using the unseal keys generated above.

```bash
# On each pod:
vault operator unseal <Unseal-Key-1>
vault operator unseal <Unseal-Key-2>
vault operator unseal <Unseal-Key-3>
```

### 3. Verify Status
```bash
vault status
# Expected Output: Sealed: false, Mode: active (or standby)
```

---

## 🔧 Maintenance & Operations

- **Unsealing**: If pods restart, they will reseal automatically. You must manually unseal them unless you configure Auto-Unseal (e.g., with AWS KMS, GCP KMS).
- **Upgrading**: `helm upgrade vault hashicorp/vault -n vault -f values.yaml`. Follow HashiCorp's upgrade guide for major versions.
- **Snapshot (Backup)**:
  ```bash
  vault operator raft snapshot save /tmp/backup.snap
  ```

---

## 📊 Monitoring & Alerts

- **Metrics**: Vault exposes metrics at `/v1/sys/metrics`.
- **Prometheus**: Configure Prometheus to scrape the Vault service.

---

## ❓ Troubleshooting

Common issues and fixes:

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| `vault status` connection refused | Vault is not initialized or pods are not running | Check `kubectl get pods` |
| Pods stuck in `CrashLoopBackOff` | Configuration error or OOM | Check logs `kubectl logs vault-0` |
| "Vault is sealed" | Pod restarted | Run `vault operator unseal` |

---

## 📚 References

- [Official Vault Documentation](https://developer.hashicorp.com/vault/docs)
- [Vault Helm Chart](https://github.com/hashicorp/vault-helm)
- [Vault on Kubernetes Deployment Guide](https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-raft-deployment-guide)
