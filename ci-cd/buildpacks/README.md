# Cloud Native Buildpacks

> **Description:** Transform application source code into images that can run on any cloud.
> **Website:** [buildpacks.io](https://buildpacks.io/)

---

## 🏗️ Concept

Buildpacks detect your source code language (e.g., Java, Go, Node.js) and automatically build a container image without needing a `Dockerfile`.

- **Builder:** An image containing all the necessary buildpacks.
- **Lifecycle:** The process that orchestrates the build.

---

## 🚀 Installation

### Install `pack` CLI

**macOS:**
```bash
brew install buildpacks/tap/pack
```

**Linux:**
```bash
sudo add-apt-repository ppa:cncf-buildpacks/pack-cli
sudo apt-get update
sudo apt-get install pack-cli
```

---

## 💻 Usage

### 1. Build an Image
Navigate to your source code directory and run:

```bash
pack build my-app --builder paketobuildpacks/builder:base
```

### 2. Run the Image
```bash
docker run --rm -p 8080:8080 my-app
```

### 3. Rebase (Update Base Image)
Update the OS layer without rebuilding the app layer (fast security patching):
```bash
pack rebase my-app
```

---

## 🧩 Integration

### kpack (Kubernetes)
`kpack` is a Kubernetes-native implementation of Buildpacks.

1. **Install kpack:**
   ```bash
   kubectl apply -f https://github.com/pivotal/kpack/releases/download/v0.12.0/release-0.12.0.yaml
   ```

2. **Create Image Resource:**
   ```yaml
   apiVersion: kpack.io/v1alpha2
   kind: Image
   metadata:
     name: my-app
   spec:
     tag: my-registry.com/my-app
     serviceAccountName: service-account
     builder:
       name: my-builder
       kind: Builder
     source:
       git:
         url: https://github.com/my-org/my-app
         revision: main
   ```

### Tekton
You can use the `buildpacks` task in Tekton pipelines to build images as part of your CI/CD workflow.
