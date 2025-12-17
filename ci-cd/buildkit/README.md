# BuildKit Guide

## Introduction to BuildKit

BuildKit is a modern build subsystem in Docker/Moby, designed to improve performance, storage management, and extensibility. It converts build definitions (like Dockerfiles) into an intermediate representation (LLB - Low-Level Builder) and executes them efficiently.

## Key Features

- **Concurrent Solving:** BuildKit can execute build steps in parallel where possible, significantly speeding up builds.
- **Advanced Caching:** Supports more efficient caching mechanisms, including import/export of cache to external registries.
- **Secrets Management:** Allows mounting secrets safely during the build process without leaking them into the final image.
- **SSH Forwarding:** Enables secure access to private repositories using SSH keys from the host.
- **Frontend/Backend Separation:** Decouples the frontend (e.g., Dockerfile) from the backend (execution), allowing new frontends to be developed easily.

## Installation / Setup

BuildKit is integrated into modern Docker versions (18.09+).

### Enable BuildKit in Docker

You can enable it for a single build:

```bash
DOCKER_BUILDKIT=1 docker build .
```

Or enable it globally in `/etc/docker/daemon.json`:

```json
{
  "features": {
    "buildkit": true
  }
}
```

### Using Docker Buildx

`docker buildx` is a CLI plugin that extends the Docker command with the full support of BuildKit features.

```bash
# Create a new builder instance
docker buildx create --name mybuilder --use

# Inspect the builder
docker buildx inspect --bootstrap
```

### Standalone `buildctl`

For advanced users or non-Docker environments (like Kubernetes), you can use the standalone `buildkitd` daemon and `buildctl` client.

```bash
# Start buildkitd
sudo buildkitd

# Build using buildctl
buildctl build \
    --frontend=dockerfile.v0 \
    --local context=. \
    --local dockerfile=. \
    --output type=image,name=docker.io/username/image:tag,push=true
```

## Usage Examples

### 1. Multi-Platform Buildings

BuildKit makes it easy to build images for multiple architectures (e.g., amd64, arm64) simultaneously.

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t myimage:latest --push .
```

### 2. Secrets Mounting

Safely use secrets without persisting them in the image layer.

**Dockerfile:**
```dockerfile
# syntax=docker/dockerfile:1
FROM alpine
RUN --mount=type=secret,id=mysecret \
    cat /run/secrets/mysecret && ...
```

**Build Command:**
```bash
docker buildx build --secret id=mysecret,src=./secret-file.txt .
```

### 3. SSH Forwarding

Clone private repos using your host's SSH agent.

**Dockerfile:**
```dockerfile
# syntax=docker/dockerfile:1
FROM alpine
RUN apk add --no-cache openssh-client git
mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh git clone git@github.com:myorg/private-repo.git
```

**Build Command:**
```bash
docker buildx build --ssh default .
```

### 4. Cache Export/Import

Speed up CI pipelines by saving build cache to a registry.

```bash
docker buildx build \
  --cache-to type=registry,ref=user/app:buildcache,mode=max \
  --cache-from type=registry,ref=user/app:buildcache \
  -t user/app:latest .
```

## Best Practices

1.  **Use specific syntax versions:** Always start your Dockerfile with `# syntax=docker/dockerfile:1` to ensure you're using the latest stable frontend features.
2.  **Leverage Caching:** Use `--cache-to` and `--cache-from` in CI/CD pipelines to drastically reduce build times.
3.  **Minimize Context:** Use `.dockerignore` to avoid sending unnecessary files to the build context.
4.  **Multi-Stage Builds:** Still highly relevant with BuildKit for keeping final image sizes small. BuildKit optimizes the execution graph to skip unused stages.
