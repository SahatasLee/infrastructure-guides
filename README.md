# 📚 Infrastructure Guides

Welcome to the **Infrastructure Guides** repository. This is a central knowledge base for setting up, configuring, and maintaining self-hosted infrastructure and DevOps tools.

## 🗂 Project Structure

Guides are organized by category. Click on the link to view specific documentation.

### 🚀 CI/CD & DevOps
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[GitLab (Self-Hosted)](./ci-cd/gitlab-self-hosted)** | Full setup guide for Omnibus/Helm installation. | |
| **[ArgoCD](./ci-cd/argocd)** | GitOps continuous delivery tool for Kubernetes. | |
| **[Harbor](./ci-cd/harbor)** | Trusted cloud native registry. | |
| **[SonarQube](./ci-cd/sonarqube)** | Code Quality and Security. | Community Edition |
| **[Buildpacks](./ci-cd/buildpacks)** | Cloud Native Buildpacks. | `pack` CLI |

### 🌐 Networking
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[Istio](./networking/istio)** | Service Mesh for Kubernetes. | `istioctl` / Helm |
| **[Karmada](./networking/karmada)** | Multi-Cluster Orchestration. | `karmadactl` / Helm |

### 🔒 Security
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[Kyverno](./security/kyverno)** | Kubernetes Native Policy Management. | |
| **[HashiCorp Vault](./security/vault)** | Secrets management and encryption. | HA / Raft |
| **[Cert-Manager](./security/cert-manager)** | X.509 certificate management for K8s. | |
| **[Keycloak](./security/keycloak)** | Identity and Access Management. | Bitnami Chart |

### 🗄️ Data & Messaging
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[Apache Kafka](./data/kafka)** | Distributed event streaming platform. | Strimzi Operator |
| **[TiDB](./data/tidb)** | Open-source distributed SQL database. | |
| **[Redis](./data/redis)** | In-memory data structure store. | Opstree Operator |
| **[PostgreSQL](./data/postgresql)** | Relational database. | CloudNativePG |

### 💾 Storage
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[OpenEBS](./storage/openebs)** | Containerized storage for containers (CAS). | |
| **[Longhorn](./storage/longhorn)** | Cloud-native distributed block storage. | |
| **[Rook-Ceph](./storage/rook-ceph)** | Ceph storage orchestrator (Block/Object/File). | |
| **[MinIO](./storage/minio)** | High Performance Object Storage (S3). | MinIO Operator |
| **[Velero](./storage/velero)** | Backup and Disaster Recovery. | AWS/S3 Plugin |

### 🛠️ Utilities & Monitoring
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[Kube-Prometheus-Stack](./monitoring/kube-prometheus-stack)** | Full monitoring stack. | |
| **[Prometheus](./monitoring/prometheus)** | Metrics collection and alerting. | Standalone |
| **[Grafana](./monitoring/grafana)** | Visualization and dashboarding. | Standalone |
| **[Loki](./monitoring/loki)** | Log aggregation (PLG Stack). | Alloy Collector |
| **[Tempo](./monitoring/tempo)** | Distributed tracing. | |
| **[Thanos](./monitoring/thanos)** | Highly available Prometheus metrics. | |
| **[Elasticsearch](./monitoring/elasticsearch)** | Distributed search and analytics. | Log Monitoring |
| **[Mimir](./monitoring/mimir)** | Scalable long-term storage for Prometheus. | |
| **[OpenCost](./monitoring/opencost)** | Kubernetes cost monitoring and allocation. | |

---

## 📁 Repository Layout

The recommended directory structure for this repository:

```text
infrastructure-guides/
├── README.md              
├── ci-cd/
│   ├── argocd/
│   ├── buildpacks/
│   ├── gitlab-self-hosted/
│   ├── harbor/
│   └── sonarqube/
├── data/
│   ├── kafka/
│   ├── postgresql/
│   ├── redis/
│   └── tidb/
├── monitoring/
│   ├── elasticsearch/
│   ├── grafana/
│   ├── kube-prometheus-stack/
│   ├── loki/
│   ├── mimir/
│   ├── prometheus/
│   ├── tempo/
│   └── thanos/
├── networking/
│   └── istio/
├── security/
│   ├── cert-manager/
│   ├── keycloak/
│   ├── kyverno/
│   └── vault/
├── storage/
│   ├── longhorn/
│   ├── minio/
│   ├── openebs/
│   ├── rook-ceph/
│   └── velero/
└── templates/
    └── _GUIDE_TEMPLATE.md  
```