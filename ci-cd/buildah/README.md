# Buildah Guide

## Introduction to Buildah

Buildah is a command-line tool for building Open Container Initiative (OCI) compatible container images. Unlike Docker, **Buildah does not require a running daemon** to function. It facilitates building container images either from a Dockerfile or by running commands against a running container "scratch" area.

## Buildah vs Podman vs Docker

| Feature | Docker | Podman | Buildah |
| :--- | :--- | :--- | :--- |
| **Daemon** | Yes (`dockerd`) | No (Fork/Exec) | No (Fork/Exec) |
| **Primary/Main Focus** | All-in-one (Build, Run, Manage) | Running & Managing Containers/Pods | Building Images |
| **Rootless Support** | Yes (with config) | Native / Default | Native / Default |
| **Image Format** | Docker / OCI | Docker / OCI | Docker / OCI |

- **Docker:** The traditional, all-purpose container platform.
- **Podman:** A daemonless alternative to Docker for *running* containers. It actually uses Buildah code internally to perform builds (`podman build`).
- **Buildah:** A specialized tool strictly for *creating* containers. It provides fine-grained control over image layers and commits.

## Installation

Buildah is available on most Linux distributions.

**Fedora / RHEL / CentOS:**
```bash
sudo dnf install buildah
```

**Ubuntu / Debian:**
```bash
sudo apt-get update
sudo apt-get install buildah
```

**macOS:**
Buildah runs natively on Linux. On macOS, you typically run it inside a Linux VM (like via Podman Machine).
```bash
brew install podman
podman machine init
podman machine start
# Then access buildah inside the machine
podman machine ssh
```

## Usage Examples

### 1. Building from a Dockerfile (`bud`)

The most common usage is similar to `docker build`. `bud` stands for "build-using-dockerfile".

```bash
buildah bud -t my-app:latest .
```

### 2. Scripting Builds (The "Buildah Way")

One of Buildah's superpowers is the ability to build images using standard shell scripts instead of a Dockerfile. This allows for complex logic, dynamic variables, and using host tools.

```bash
#!/bin/bash
set -e

# Start with a base image
container=$(buildah from alpine)

# Mount the container's root filesystem to the host
# This allows using host tools (like dnf/apt) to install packages into the container!
mnt=$(buildah mount $container)

# Run commands "inside" the container image
buildah run $container -- apk add --no-cache python3

# Copy files
buildah copy $container ./src /app

# Configure entrypoint
buildah config --entrypoint '["python3", "/app/main.py"]' $container

# Commit the container to an image
buildah commit $container my-scripted-image:latest

# Clean up
buildah rm $container
```

### 3. Rootless Builds

Buildah excels at rootless builds, allowing users to build images without `sudo` privileges, improving security in CI environments.

```bash
# Just run it as a normal user!
buildah bud -t my-rootless-image .
```

Note: This requires proper subuid/subgid mapping configuration on the host (usually handled by `newuidmap`/`newgidmap`).

## Best Practices

1.  **Use `buildah unshare`:** When running build scripts interactively as a rootless user, you might need to enter a user namespace.
    ```bash
    buildah unshare ./my-build-script.sh
    ```
2.  **Clean up:** Since Buildah creates working containers (`buildah from`), remember to remove them (`buildah rm`) after committing to save disk space.
3.  **Layers:** `buildah commit` creates a layer. If you are scripting, be mindful of when you commit. You can perform multiple actions before committing to keep layer count low.
