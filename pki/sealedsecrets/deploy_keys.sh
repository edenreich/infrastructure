#!/bin/bash

set -e

for context in $(echo build staging production gateway | xargs); do
  echo "==> Deploying Bitnami Sealed Secrets private and public keys to ${context}..."
  echo "===> Creating namespace sealed-secrets if not exists..."
  kubectl create namespace sealed-secrets \
    --context=$context \
    --dry-run=client --output yaml | kubectl --context=$context apply -f -

  echo "===> Creating TLS secret for given private and public keys..."
  kubectl create secret tls sealed-secrets \
    --context=$context \
    --namespace=sealed-secrets \
    --cert=./sealed-secrets-tls.crt \
    --key=./sealed-secrets-tls.key \
    --dry-run=client --output yaml | kubectl --context=$context apply -f -

  echo "===> Activating TLS secret for given private and public keys..."
  kubectl label secret sealed-secrets sealedsecrets.bitnami.com/sealed-secrets-key=active \
    --context=$context \
    --namespace=sealed-secrets
done;
