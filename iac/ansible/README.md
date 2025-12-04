# Ansible Guide

> **Description:** Open-source automation tool for configuration management, application deployment, and task automation.
> **Version:** Core 2.15+ (Example)

---

## 🏗️ Concepts

- **Inventory:** List of managed nodes (hosts).
- **Playbook:** YAML file defining automation tasks.
- **Module:** Code that performs a specific task (e.g., `apt`, `copy`, `service`).
- **Role:** Reusable unit of organization for playbooks.

---

## 📋 Prerequisites

- Python 3.8+ installed on the control node.
- SSH access to managed nodes.

---

## 🚀 Installation

### macOS
```bash
brew install ansible
```

### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install ansible
```

---

## ⚙️ Configuration

### 1. Create Inventory (`hosts`)
```ini
[webservers]
192.168.1.10
192.168.1.11

[dbservers]
192.168.1.20
```

### 2. Configure `ansible.cfg` (Optional)
```ini
[defaults]
inventory = ./hosts
remote_user = ubuntu
private_key_file = ~/.ssh/id_rsa
host_key_checking = False
```

---

## 💻 Usage

### Ad-Hoc Commands
Run a single command on all webservers:
```bash
ansible webservers -m ping
ansible webservers -m shell -a "uptime"
```

### Running a Playbook
```bash
ansible-playbook playbook.yml
```

---

## 📝 Example Playbook

See `playbook.yml` for a complete example that installs Nginx.

```yaml
---
- name: Configure Web Servers
  hosts: webservers
  become: yes
  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present
        update_cache: yes
```

---

## ✅ Verification

### 1. Check Connectivity
```bash
ansible all -m ping
```

### 2. Verify Configuration
Check if Nginx is running on target hosts:
```bash
ansible webservers -m service_facts
```

---

## 🧹 Maintenance

### Update Ansible
```bash
pip install --upgrade ansible
```
