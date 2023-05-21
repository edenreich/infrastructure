## Clusters

Add each cluster from the current config using ArgoCD CLI:

```sh
# argocd cluster add build --project build # Not needed - use in-cluster
argocd cluster add staging --project staging
argocd cluster add production --project production
argocd cluster add gateway --project gateway
```

The subdirectories contain the manifests for each cluster, which are applied using ArgoCD app of apps pattern.
