# Cloud Native Buildpacks Guide

> **Transform application source code into container images without Dockerfiles.**

[Cloud Native Buildpacks](https://buildpacks.io/) (CNB) provide a higher-level abstraction for building container images. They detect your application language, install dependencies, and configure the runtime environment automatically.

---

## 🏗️ Core Concepts

### How it Works
1.  **Detection**: Buildpacks check if they apply to your code (e.g., "Is there a `go.mod`?", "Is there a `package.json`?").
2.  **Build**: If detected, the buildpack contributes layers to the final image (e.g., installs Go, runs `go build`).
3.  **Export**: The layers are assembled into a standard OCI container image.

### Key Components
-   **Builder**: An image containing a collection of buildpacks and a lifecycle runner.
-   **Lifecycle**: The orchestrator that runs the detection and build phases.
-   **Stack**: The underlying OS image (run image + build image).

---

## 🚀 Installation (`pack` CLI)

The `pack` CLI is the standard tool for using buildpacks locally.

**macOS**
```bash
brew install buildpacks/tap/pack
```

**Linux (Ubuntu/Debian)**
```bash
sudo add-apt-repository ppa:cncf-buildpacks/pack-cli
sudo apt-get update
sudo apt-get install pack-cli
```

---

## 💻 Usage Guide

### 1. Basic Build
Build an image from the source code in the current directory.

```bash
pack build my-app-image \
    --builder paketobuildpacks/builder:base
```

### 2. Choosing a Builder
Different builders support different languages and valid sets.

| Provider | Builder Image | Features |
| :--- | :--- | :--- |
| **Paketo** | `paketobuildpacks/builder:base` | General purpose (Java, Go, Node, Python, .NET). Optimized for Spring Boot. |
| **Paketo (Tiny)** | `paketobuildpacks/builder:tiny` | Distroless-like, Golang/Java native apps only. |
| **Google** | `gcr.io/buildpacks/builder:v1` | Supports Go, Java, Node.js, Python, .NET. Used by Google Cloud Run. |
| **Heroku** | `heroku/builder:22` | The classic Heroku experience. |

### 3. Configuring via `project.toml`
Create a `project.toml` file in your root directory to configure the build without CLI flags.

```toml
# project.toml
[project]
  name = "my-awesome-app"

[build]
  builder = "paketobuildpacks/builder:base"
  exclude = [".git", "node_modules"]

[[build.env]]
  name = "BP_GO_BUILD_FLAGS"
  value = "-buildmode=default"

[[build.env]]
  name = "BP_NODE_VERSION"
  value = "18.16.0"
```

Run `pack build my-app` and it will pick up configuration from `project.toml`.

---

## ⚙️ Advanced Features

### Fast Security Patching (Rebase)
Buildpacks separate the OS layer (Stack) from the App layer. You can update the OS layer (e.g., to fix a CVE in glibc) without rebuilding your application.

```bash
# Updates the run image to the latest version instantly
pack rebase my-app-image
```

### Binding Services (Credentials/Configs)
Inject credentials or configuration files at build time or runtime.

```bash
pack build my-app \
    --volume $(pwd)/binding:/platform/bindings/my-binding \
    --builder paketobuildpacks/builder:base
```

### Offline Builds
Publishers often provide "full" builders that contain all buildpacks and dependencies offline.

```bash
pack build my-app-offline \
    --network none \
    --builder paketobuildpacks/builder:full
```

---

## 🧩 CI/CD Integration

### GitHub Actions
Use the official `buildpacks/github-actions/setup-pack` action.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: buildpacks/github-actions/setup-pack@v5.0.0
      - name: Build App
        run: pack build my-registry.com/my-app --builder paketobuildpacks/builder:base --publish
```

### Kubernetes (kpack)
[kpack](https://github.com/pivotal/kpack) is a Kubernetes operator that continuously builds images using Cloud Native Buildpacks.

1.  **Define a `Builder`** (What buildpacks to use).
2.  **Define an `Image`** (Source code location + Tag).
3.  kpack watches the Git repo and automatically rebuilds the image on commit.

---

## ❓ Troubleshooting

**"No buildpack detected"**
-   Ensure your project follows standard layout (e.g., `go.mod` for Go, `pom.xml` for Java).
-   Try specifying the buildpack explicity: `pack build my-app --buildpack paketo-buildpacks/go`.

**"Build failed during execution"**
-   Run with verbose logs: `pack build ... --verbose`.
-   Check "Build Configuration" docs for your specific buildpack (e.g., Paketo specific env vars).

**"Image too large"**
-   Switch to a smaller builder/stack (e.g., `paketobuildpacks/builder:tiny`).
-   Review `.dockerignore` (or `exclude` in `project.toml`) to ensure you aren't copying unnecessary files.
