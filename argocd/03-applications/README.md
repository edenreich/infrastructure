## Applications

This setup is based on a bare minimum fresh installation of Linode Kubernetes Engine(LKE).

**Note:** **05-github-actions-runner-secret.yaml** make sure the secret is encrypted with the new private key of the deployed sealed-secrets instance so it can be decrypted inside of the cluster correctly.

To generate that secret run:

```sh
kubectl create secret generic --namespace actions-runner-system --from-literal=github_token=<token> controller-manager --dry-run=client -o yaml > rawsecret.yaml
kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets --format yaml < rawsecret.yaml > 04-github-actions-runner-secret.yaml
rm rawsecret.yaml
git add ./05-github-actions-runner-secret.yaml
git commit -m "Add encrypted github runner secret"
git push
```
