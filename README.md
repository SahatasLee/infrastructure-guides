# 📚 Infrastructure Guides

Welcome to the **Infrastructure Guides** repository. This is a central knowledge base for setting up, configuring, and maintaining self-hosted infrastructure and DevOps tools.

## 🗂 Project Structure

Guides are organized by category. Click on the link to view specific documentation.

### 🚀 CI/CD & DevOps
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[GitLab (Self-Hosted)](./ci-cd/gitlab)** | Full setup guide for Omnibus/Helm installation. | |
| **[ArgoCD](./ci-cd/argocd)** | GitOps continuous delivery tool for Kubernetes. | |

### 🗄️ Data & Messaging
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[Apache Kafka](./data/kafka)** | Distributed event streaming platform. | Kraft mode / Zookeeper |
| **[TiDB](./data/tidb)** | Open-source distributed SQL database. | |
| **[Redis](./data/redis)** | In-memory data structure store. | |

### 💾 Storage
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[OpenEBS](./storage/openebs)** | Containerized storage for containers (CAS). | |
| **[Longhorn](./storage/longhorn)** | Cloud-native distributed block storage. | |

### 🛠️ Utilities & Monitoring
| Tool | Description | Version/Note |
| :--- | :--- | :--- |
| **[Cert-Manager](./utils/cert-manager)** | X.509 certificate management for K8s. | |
| **[Prometheus/Grafana](./monitoring)** | Monitoring and alerting stack. | |
| **[Loki](./monitoring/logging)** | Logging stack. | |

---

## 📁 Repository Layout

The recommended directory structure for this repository:

```text
infrastructure-guides/
├── README.md              
├── ci-cd/
│   ├── gitlab/
│   │   ├── README.md       
│   │   └── values.yaml     
│   └── argocd/
├── data/
│   ├── kafka/
│   └── tidb/
├── storage/
│   └── openebs/
└── templates/
    └── _GUIDE_TEMPLATE.md  
```