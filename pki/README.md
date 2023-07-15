## PKI

- [Sealed Secrets](#deploying-sealed-secrets-keys)
- [Cloudflare TLS Certificates](#deploying-cloudflare-keys)

### Deploying Sealed Secrets keys

```bash
SEALED_SECRETS_TLS_CERT=<path> SEALED_SECRETS_TLS_KEY=<path> make deploy-sealed-secrets-keys
```

For cleaning up all the sealed secrets keys:
```bash
make cleanup-sealed-secrets-keys
```

### Deploying Cloudflare keys

```bash
CLOUDFLARE_TLS_CERT=<path> CLOUDFLARE_TLS_KEY=<path> make deploy-cloudflare-keys
```
