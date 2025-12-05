# Kafdrop POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `kafka` namespace exists.
- [ ] **Kafka Cluster Ready**: Kafka cluster is running.

## 2. Deployment & Installation
- [ ] **Apply Manifests**: `deployment.yaml` and `service.yaml` applied.
- [ ] **Pod Ready**: Kafdrop pod is `Running`.

## 3. Functional Testing
- [ ] **Web UI Access**: Can access Kafdrop via port-forward (http://localhost:9000).
- [ ] **Cluster Info**: UI shows correct broker information.
- [ ] **Topic List**: UI lists existing topics (e.g., `test-topic`).
- [ ] **Message Browsing**: Can view messages in a topic.

## 4. Cleanup
- [ ] **Delete Resources**: Deployment and Service deleted.
