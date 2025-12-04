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

### 🛠️ Utilities & Monitoring
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[Cert-Manager](./utils/cert-manager)** | X.509 certificate management for K8s. | |
| **[HashiCorp Vault](./utils/vault)** | Secrets management and encryption. | HA / Raft |
| **[Kube-Prometheus-Stack](./monitoring/kube-prometheus-stack)** | Full monitoring stack. | |
| **[Prometheus](./monitoring/prometheus)** | Metrics collection and alerting. | Standalone |
| **[Grafana](./monitoring/grafana)** | Visualization and dashboarding. | Standalone |
| **[Loki](./monitoring/loki)** | Log aggregation (PLG Stack). | Alloy Collector |
| **[Tempo](./monitoring/tempo)** | Distributed tracing. | |
| **[Thanos](./monitoring/thanos)** | Highly available Prometheus metrics. | |

---

## 📁 Repository Layout

The recommended directory structure for this repository:

```text
infrastructure-guides/
├── README.md              
├── ci-cd/
│   ├── argocd/
│   ├── gitlab-self-hosted/
│   └── harbor/
├── data/
│   ├── kafka/
│   ├── postgresql/
│   ├── redis/
│   └── tidb/
├── monitoring/
│   ├── grafana/
│   ├── kube-prometheus-stack/
│   ├── loki/
│   ├── prometheus/
│   ├── tempo/
│   └── thanos/
├── storage/
│   ├── longhorn/
│   ├── minio/
│   ├── openebs/
│   └── rook-ceph/
├── utils/
│   ├── cert-manager/
│   └── vault/
└── templates/
    └── _GUIDE_TEMPLATE.md  
```