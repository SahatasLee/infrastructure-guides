# SonarQube POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `sonarqube` namespace exists.
- [ ] **Helm Repo Added**: SonarSource repo added.
- [ ] **Storage Class**: Valid storage class confirmed.
- [ ] **Ingress Controller**: NGINX Ingress controller is running.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: `sonarqube` and `postgresql` pods are `Running`.
- [ ] **PVCs Bound**: Persistent Volume Claims are `Bound`.

## 3. Functional Testing
- [ ] **UI Access**: Can access `http://sonar.example.com` (or port-forwarded URL).
- [ ] **Login**: Can login with `admin` / `admin`.
- [ ] **Password Change**: Forced password change on first login works.
- [ ] **Project Creation**: Can create a new project manually.
- [ ] **Token Generation**: Can generate an analysis token.

## 4. Integration Testing
- [ ] **Scanner Run**: Can run `sonar-scanner` locally against the server.
- [ ] **Report View**: Analysis results appear in the UI.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall sonarqube -n sonarqube`
- [ ] **PVC Cleanup**: PVCs deleted.
