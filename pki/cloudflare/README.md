## Cloudflare

### Deploy TLS Certificates

1. First download the Cloudflare certificates to the current directory and call them `eden-reich.com.key` and `eden-reich.com.pem`.

2. Finally deploy them onto gateway cluster by running:
```sh
./deploy_certificates.sh
```
