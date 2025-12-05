# Kafbat UI POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `kafka` namespace exists.
- [ ] **Helm Repo Added**: Kafbat repo added.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: Kafbat UI pod is `Running`.

## 3. Configuration
- [ ] **Cluster Connection**: UI successfully connects to the Kafka cluster.
- [ ] **Authentication**: SASL/SCRAM credentials are working.

## 4. Functional Testing
- [ ] **Web UI Access**: Can access UI via port-forward (http://localhost:8080).
- [ ] **Topic List**: UI lists existing topics.
- [ ] **Consumer Groups**: UI lists consumer groups.
- [ ] **Message Browsing**: Can view messages in a topic.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall kafbat-ui -n kafka` executed.
