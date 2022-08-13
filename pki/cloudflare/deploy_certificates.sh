#!/bin/bash

set -e

echo "===> Deploying Cloudflare TLS Certificates..."
echo "====> Creating namespace main..." 
kubectl create namespace main \
  --context=gateway \
  --dry-run=client --output yaml | kubectl --context=gateway apply -f -

echo "====> Creating tls secret eden-reich.com-tls..."
kubectl create secret tls eden-reich.com-tls \
  --context=gateway \
  --namespace=main \
  --cert=./eden-reich.com.pem \
  --key=./eden-reich.com.key \
  --dry-run=client --output=yaml | kubectl --context=gateway apply -f -
