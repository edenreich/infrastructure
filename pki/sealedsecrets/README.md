## Sealed Secrets

### Deploy encryption keys

1. First download the keys to the current directory and call them `sealed-secrets-tls.crt` and `sealed-secrets-tls.key`.

2. Finally run the following command to create the secret of type tls in all of the clusters:
```sh
./deploy_keys.sh
```
