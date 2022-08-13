## Infrastructure

The purpose of this project is to contain all the infrastructure in GitOps.

### Setup

- There are 4 projects: build, staging, production and gateway
- There are 4 clusters: build, staging, production and gateway
- Deployments of nginx ingresses to staging, production and gateway
- Github actions runners definitions is declared in each application repository
