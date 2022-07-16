## ArgoCD

### Install

```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443
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
