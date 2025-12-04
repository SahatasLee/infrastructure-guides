# Let's Encrypt POC Checklist

## 1. Standalone (Certbot)
- [ ] **Install**: Certbot installed successfully.
- [ ] **Dry Run**: `certbot certonly --dry-run` completes without error.
- [ ] **Issuance**: Certificate issued for a test domain (if available).
- [ ] **Renewal**: `certbot renew --dry-run` passes.

## 2. Kubernetes (Cert-Manager)
- [ ] **Prerequisite**: Cert-Manager is installed and running.
- [ ] **ClusterIssuer**: `letsencrypt-prod` (or staging) ClusterIssuer is `Ready`.
- [ ] **Ingress**: Ingress created with `cert-manager.io/cluster-issuer` annotation.
- [ ] **Certificate**: Certificate resource created and status is `Ready`.
- [ ] **Secret**: TLS secret exists and contains keys.
- [ ] **HTTPS**: Application is accessible via HTTPS with a valid certificate.
