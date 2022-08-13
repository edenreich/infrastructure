## Clusters

Add each cluster from the current config using ArgoCD CLI:

```sh
argocd cluster add build --project build
argocd cluster add staging --project staging
argocd cluster add production --project production
argocd cluster add gateway --project gateway
```
