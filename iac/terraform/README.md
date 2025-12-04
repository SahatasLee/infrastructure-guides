# Terraform Guide

> **Description:** Infrastructure as Code tool for building, changing, and versioning infrastructure safely and efficiently.
> **Version:** 1.5+ (Example)

---

## 🏗️ Concepts

- **Provider:** Plugin to interact with APIs (e.g., AWS, Docker, Kubernetes).
- **Resource:** Infrastructure object (e.g., EC2 instance, S3 bucket).
- **State:** File (`terraform.tfstate`) that maps real world resources to your configuration.
- **Module:** Container for multiple resources that are used together.

---

## 📋 Prerequisites

- Terraform CLI installed.
- Access credentials for your target provider (e.g., AWS keys, Docker socket).

---

## 🚀 Installation

### macOS
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Linux (Ubuntu/Debian)
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

---

## ⚙️ Configuration

### 1. Initialize Directory
```bash
terraform init
```

### 2. Plan Changes
Preview what Terraform will do:
```bash
terraform plan
```

### 3. Apply Changes
Provision the infrastructure:
```bash
terraform apply
```

---

## 💻 Usage

### Managing State
List resources in state:
```bash
terraform state list
```

### Destroying Infrastructure
Remove all resources defined in the configuration:
```bash
terraform destroy
```

---

## 📝 Example Configuration

See `main.tf` for a complete example that manages a Docker container.

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}
```

---

## ✅ Verification

### 1. Check Output
After `terraform apply`, check the output for success message.

### 2. Verify Resource
Check if the resource exists (e.g., `docker ps`).

---

## 🧹 Maintenance

### Format Code
```bash
terraform fmt
```

### Validate Configuration
```bash
terraform validate
```
