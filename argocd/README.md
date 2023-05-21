## ArgoCD

### Install

```sh
kubectl config use-context build
helm repo update
helm upgrade --install argocd argo/argo-cd --namespace argocd --create-namespace --wait
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

### Fetching initial password

```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

### Login using the UI
Open http://localhost:8080

Username: admin
Password: <password>

### Login using the CLI

```sh
argocd login '127.0.0.1:8080' --insecure
```
