## Infrastructure

The purpose of this project is to contain all the infrastructure in GitOps.

### Setup

- There are 4 projects: build, staging, production and gateway
- There are 4 clusters: build, staging, production and gateway
- Deployments of nginx ingresses to staging, production and gateway
- Github actions runners definitions is declared in each application repository

### Secrets

Secrets are being encrypted using bitnami sealed-secrets - a very simple solution for having native kubernetes secrets objects as kind SealedSecret versioned in git and they are also secure.

The same RSA private key and cert is deployed to all clusters.
Might be good to rotate this key once in a while.
