# Ansible POC Checklist

## 1. Environment Setup
- [ ] **Ansible Installed**: `ansible --version` returns valid version.
- [ ] **Inventory Created**: `hosts` file exists with target IP addresses.
- [ ] **SSH Access**: Can SSH into target nodes without password (key-based auth).

## 2. Connectivity Test
- [ ] **Ping Test**: `ansible all -m ping -i hosts` returns `pong` for all nodes.

## 3. Playbook Execution
- [ ] **Syntax Check**: `ansible-playbook playbook.yml --syntax-check` passes.
- [ ] **Dry Run**: `ansible-playbook playbook.yml --check` runs without errors.
- [ ] **Actual Run**: `ansible-playbook playbook.yml` completes successfully.

## 4. Verification
- [ ] **Service Status**: Nginx (or target service) is running on target nodes.
- [ ] **File Content**: Custom `index.html` exists and has correct content.
- [ ] **Idempotency**: Running the playbook again results in `changed=0`.

## 5. Cleanup
- [ ] **Package Removal**: `ansible all -m package -a "name=nginx state=absent" --become` (Optional).
