# Falco on Kubernetes

> **Description:** Cloud-native runtime security tool.
> **Version:** 0.37.0 (Example)

---

## 🏗️ Architecture

- **Falco Pods:** Deployed as a DaemonSet on every node.
- **Kernel Module / eBPF:** Intercepts system calls.
- **Rules Engine:** Evaluates system calls against rules.
- **Falco Sidekick (Optional):** Forwards events to various outputs (Slack, Datadog, WebUI).

---

## 📋 Prerequisites

- Kubernetes Cluster 1.20+
- Helm 3+
- Kernel headers installed on nodes (usually handled by Falco driver loader).

---

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
```

### 2. Install Falco
```bash
helm upgrade --install falco falcosecurity/falco \
  --namespace falco \
  --create-namespace \
  --values values.yaml \
  --version 3.8.0
```

---

## ⚙️ Configuration

Key configurations in `values.yaml`:

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `driver.kind` | `ebpf` | Use eBPF probe (safer for managed K8s like GKE/EKS). |
| `falcosidekick.enabled` | `true` | Enable Sidekick for UI/Alerting. |
| `falcosidekick.webui.enabled` | `true` | Enable Falco Web UI. |

---

## 💻 Usage

### 1. Access Web UI
```bash
kubectl port-forward svc/falco-falcosidekick-ui 2802:2802 -n falco
```
Open `http://localhost:2802`.

### 2. Trigger a Test Alert
Exec into a pod and run a suspicious command:
```bash
kubectl exec -it <some-pod> -- /bin/bash -c "cat /etc/shadow"
```
*Note: You should see an alert in the logs or Web UI.*

### 3. Check Logs
```bash
kubectl logs -l app.kubernetes.io/name=falco -n falco
```

---

## ✅ Verification

### 1. Check Pods
```bash
kubectl get pods -n falco
# Should see falco (DaemonSet) and falcosidekick
```

### 2. Verify Driver
Check logs to ensure the driver (kernel module or eBPF) loaded successfully.
```bash
kubectl logs -l app.kubernetes.io/name=falco -n falco | grep "driver loaded"
```

---

## 🧹 Maintenance

### Upgrade
```bash
helm upgrade falco falcosecurity/falco -n falco --values values.yaml --version <new-version>
```

### Uninstall
```bash
helm uninstall falco -n falco
```
