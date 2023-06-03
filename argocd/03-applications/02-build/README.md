## Applications

This setup is based on a bare minimum fresh installation of Rancher k3s cluster.

### Install

**Note:** Before you install make sure you deploy the existing private and public keys so sealed secrets can decrypt the secret into the cluster, follow [pki/sealedsecrets/README.md](https://github.com/edenreich/infrastructure/tree/main/pki/sealedsecrets).

Connect to build cluster(where ArgoCD is installed) and run:

```sh
kubectl apply -f .
```
