# Cert-Manager POC Checklist

## Phase 1: Infrastructure

- [ ] **Pod Status**: Cert-Manager pods (controller, cainjector, webhook) are `Running`.
- [ ] **CRDs**: `issuers`, `clusterissuers`, `certificates` CRDs exist.

## Phase 2: Functional Testing

- [ ] **Self-Signed Issuer**:
    - [ ] Create a SelfSigned `ClusterIssuer`.
    - [ ] Create a `Certificate` using this issuer.
    - [ ] Verify Certificate is `Ready`.
    - [ ] Verify Secret is created with `tls.crt` and `tls.key`.
- [ ] **Let's Encrypt (Staging)**:
    - [ ] Create an ACME `ClusterIssuer` (HTTP-01 or DNS-01).
    - [ ] Create a `Certificate` for a valid domain.
    - [ ] Verify Order/Challenge is successful.
    - [ ] Verify Certificate is `Ready`.

## Phase 3: Operations

- [ ] **Renewal**:
    - [ ] Manually trigger renewal: `cmctl renew <cert-name>`.
    - [ ] Verify new expiry date.
