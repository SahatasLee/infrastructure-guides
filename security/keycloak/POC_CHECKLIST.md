# Keycloak POC Checklist

## 1. Infrastructure Setup
- [ ] **Namespace Created**: `keycloak` namespace exists.
- [ ] **Helm Repo Added**: Bitnami repo added.
- [ ] **Ingress Controller**: NGINX Ingress controller is running.
- [ ] **DNS**: `auth.example.com` resolves to Ingress IP.

## 2. Deployment & Installation
- [ ] **Install Command**: Helm install executed successfully.
- [ ] **Pods Ready**: `keycloak` and `postgresql` pods are `Running`.
- [ ] **Database Connected**: Keycloak logs show successful DB connection.

## 3. Functional Testing
- [ ] **UI Access**: Can access `https://auth.example.com`.
- [ ] **Admin Login**: Can login to Admin Console.
- [ ] **Realm Creation**: Can create a new Realm.
- [ ] **User Creation**: Can create a new User in the realm.
- [ ] **Client Creation**: Can create an OIDC client.

## 4. Integration Testing (Optional)
- [ ] **App Login**: Can login to a sample app using Keycloak OIDC.

## 5. Cleanup
- [ ] **Uninstall**: `helm uninstall keycloak -n keycloak`
- [ ] **PVC Cleanup**: PVCs deleted.
