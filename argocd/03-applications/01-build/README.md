## Applications

This setup is based on a bare minimum fresh installation of Linode Kubernetes Engine(LKE).

**Note:** **05-github-actions-runner-secret.yaml** make sure the secret is encrypted with the new private key of the deployed sealed-secrets instance so it can be decrypted inside of the cluster correctly.

### Install

1. Deploy sealed secrets:
```sh
kubectl apply -f 01-sealed-secrets.yaml
```

2. Create raw secret for github runner:
```sh
kubectl create secret generic --namespace actions-runner-system --from-literal=github_token=<token> controller-manager --dry-run=client -o yaml > rawsecret.yaml
```

3. Seal the secret for github runner using kubeseal CLI:
```sh
kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets --format yaml < rawsecret.yaml > 05-github-actions-runner-secret.yaml
```

4. Remove that file or just don't commit that raw secret:
```sh
rm rawsecret.yaml
```

5. Add the new sealed secret to the cluster:
```sh
git add ./05-github-actions-runner-secret.yaml
git commit -m "Add encrypted github runner secret"
git push
```

6. Deploy the rest of the ArgoCD applications:
```sh
kubectl apply -f .
```
