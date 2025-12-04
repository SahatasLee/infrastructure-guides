# Let's Encrypt Guide

> **Description:** Free, automated, and open Certificate Authority (CA).
> **Protocol:** ACME (Automated Certificate Management Environment)

---

## 🏗️ Concepts

- **ACME Protocol:** The protocol used to communicate between the CA and your server to automate verification and issuance.
- **Challenges:**
    - **HTTP-01:** Verifies ownership by placing a file on the web server (port 80).
    - **DNS-01:** Verifies ownership by creating a TXT record in DNS (required for Wildcard certs).
- **Rate Limits:** Let's Encrypt has strict rate limits (e.g., 50 certificates per week per registered domain).

---

## 🚀 Standalone Usage (Certbot)

For non-Kubernetes environments (e.g., a single VM running Nginx).

### 1. Install Certbot
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install certbot python3-certbot-nginx
```

### 2. Obtain Certificate (Nginx)
```bash
sudo certbot --nginx -d example.com -d www.example.com
```

### 3. Auto-Renewal
Certbot automatically sets up a cron job/systemd timer. Test it:
```bash
sudo certbot renew --dry-run
```

---

## ☸️ Kubernetes Usage (via Cert-Manager)

This section assumes you have **Cert-Manager** installed (see [Cert-Manager Guide](../cert-manager)).

### 1. Create a ClusterIssuer (Production)
See `cluster-issuer.yaml` for the configuration.

```bash
kubectl apply -f cluster-issuer.yaml
```

### 2. Request a Certificate (via Ingress)
Annotate your Ingress resource to automatically request a certificate.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - example.com
    secretName: example-com-tls
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 80
```

---

## ✅ Verification

### Check Certificate Status
```bash
kubectl get certificate
# READY should be True
```

### Check Secret
```bash
kubectl get secret example-com-tls
# Should contain tls.crt and tls.key
```

---

## 🧹 Maintenance

### Revoking Certificates
```bash
sudo certbot revoke --cert-path /etc/letsencrypt/live/example.com/cert.pem
```
