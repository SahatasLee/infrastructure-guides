# HashiCorp Vault POC Checklist

## Phase 1: Infrastructure

- [ ] **Pod Status**: Vault pods are `Running`.
- [ ] **HA Status**: If HA, verify standby nodes.

## Phase 2: Access & Configuration

- [ ] **Initialization**:
    - [ ] Initialize Vault: `vault operator init`.
    - [ ] Save Unseal Keys and Root Token.
- [ ] **Unseal**:
    - [ ] Unseal all Vault pods using the keys.
    - [ ] Verify status: `vault status` -> `Sealed: false`.
- [ ] **Login**:
    - [ ] Login with Root Token.

## Phase 3: Functional Testing

- [ ] **Secrets Engine**:
    - [ ] Enable KV engine: `vault secrets enable -path=secret kv`.
- [ ] **CRUD**:
    - [ ] Write secret: `vault kv put secret/hello foo=bar`.
    - [ ] Read secret: `vault kv get secret/hello`.
- [ ] **Kubernetes Auth** (Optional):
    - [ ] Enable K8s auth method.
    - [ ] Configure role.
    - [ ] Verify a Pod can authenticate and read secrets.

## Phase 4: Operations

- [ ] **Reseal**:
    - [ ] `vault operator seal`.
    - [ ] Verify Vault is sealed.
