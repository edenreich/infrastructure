
SEALED_SECRETS_CONTEXTS ?= build staging production gateway

SEALED_SECRETS_TLS_KEY ?= ./sealedsecrets/tls.key
SEALED_SECRETS_TLS_CERT ?= ./sealedsecrets/tls.crt

CLOUDFLARE_TLS_KEY ?= ./cloudflare/eden-reich.com-tls.key
CLOUDFLARE_TLS_CERT ?= ./cloudflare/eden-reich.com-tls.pem

help:
	@printf "Usage:\n"
	@printf " make <command>\n\n"
	@printf "Commands:\n"
	@printf " cleanup-sealed-secrets-keys    Cleanup Sealed Secrets keys\n"
	@printf " deploy-sealed-secrets-keys     Deploy Sealed Secrets keys\n"
	@printf " deploy-cloudflare-keys         Deploy Cloudflare keys\n"

default: help

kubectl:
	@which kubectl > /dev/null || (echo "kubectl not installed!" && exit 1)

cleanup-sealed-secrets-keys: kubectl
	@for context in `echo ${SEALED_SECRETS_CONTEXTS} | xargs`; do \
		echo "==> Cleaning up Bitnami Sealed Secrets private and public keys for ${context}..."; \
		echo "===> Creating namespace sealed-secrets if not exists..."; \
		kubectl delete secret --all \
			--context=$$context \
			--namespace=sealed-secrets; \
	done

deploy-sealed-secrets-keys: kubectl
	@for context in `echo ${SEALED_SECRETS_CONTEXTS} | xargs`; do \
		echo "==> Deploying Bitnami Sealed Secrets private and public keys to ${context}..."; \
		echo "===> Creating namespace sealed-secrets if not exists..."; \
		kubectl create namespace sealed-secrets \
			--context=$$context \
			--dry-run=client --output yaml | kubectl --context=$$context apply -f -; \
		echo "===> Creating TLS secret for given private and public keys..."; \
		kubectl create secret tls sealed-secrets \
			--context=$$context \
			--namespace=sealed-secrets \
			--cert=${SEALED_SECRETS_TLS_CERT} \
			--key=${SEALED_SECRETS_TLS_KEY} \
			--dry-run=client --output yaml | kubectl --context=$$context apply -f -; \
		echo "===> Activating TLS secret for given private and public keys..."; \
		kubectl label secret -l sealedsecrets.bitnami.com/sealed-secrets-key=active sealedsecrets.bitnami.com/sealed-secrets-key- \
			--context=$$context \
			--namespace=sealed-secrets; \
		kubectl label secret sealed-secrets sealedsecrets.bitnami.com/sealed-secrets-key=active \
			--context=$$context \
			--namespace=sealed-secrets; \
	done

deploy-cloudflare-keys: kubectl
	@echo "===> Deploying Cloudflare TLS Certificates..."
	@echo "====> Creating namespace main..." 
	@kubectl create namespace main \
		--context=gateway \
		--dry-run=client --output yaml | kubectl --context=gateway apply -f -
	@echo "====> Creating tls secret eden-reich.com-tls..."
	@kubectl create secret tls eden-reich.com-tls \
		--context=gateway \
		--namespace=main \
		--cert=${CLOUDFLARE_TLS_CERT} \
		--key=${CLOUDFLARE_TLS_KEY} \
		--dry-run=client --output=yaml | kubectl --context=gateway apply -f -

.PHONY: help default kubectl deploy-sealed-secrets-keys deploy-cloudflare-keys
