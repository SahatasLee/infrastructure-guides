# Terraform POC Checklist

## 1. Environment Setup
- [ ] **Terraform Installed**: `terraform -v` returns valid version.
- [ ] **Provider Access**: Credentials configured (e.g., Docker running, AWS keys set).

## 2. Initialization
- [ ] **Init**: `terraform init` downloads providers successfully.
- [ ] **Validation**: `terraform validate` returns success.

## 3. Execution
- [ ] **Plan**: `terraform plan` shows expected changes (e.g., "+ 2 to add").
- [ ] **Apply**: `terraform apply -auto-approve` completes successfully.
- [ ] **State File**: `terraform.tfstate` is created.

## 4. Verification
- [ ] **Resource Existence**: Resource exists (e.g., `docker ps | grep terraform-nginx`).
- [ ] **Functionality**: Resource is functional (e.g., `curl localhost:8080`).

## 5. Cleanup
- [ ] **Destroy**: `terraform destroy -auto-approve` removes all resources.
- [ ] **State Cleanup**: `terraform.tfstate` reflects no resources.
