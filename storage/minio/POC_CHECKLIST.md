# MinIO POC Checklist

## Phase 1: Infrastructure

- [ ] **Operator Status**: MinIO Operator is `Running`.
- [ ] **Tenant Status**: Tenant pods are `Running` and `Ready`.
- [ ] **Console Access**: Can login to MinIO Console.

## Phase 2: Functional Testing

- [ ] **Bucket Operations**:
    - [ ] Create a Bucket "test-bucket".
    - [ ] Upload a file.
    - [ ] Download the file.
- [ ] **Access Keys**:
    - [ ] Create a Service Account (Access/Secret Key).
    - [ ] Configure `mc` or AWS CLI with these keys.
    - [ ] List buckets: `mc ls myminio`.

## Phase 3: Operations

- [ ] **Scaling**:
    - [ ] Add a new Pool in `minio-tenant.yaml`.
    - [ ] Verify new pods are created and joined.
