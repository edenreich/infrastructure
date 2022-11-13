
COLOR_GREEN = "\x1b[32;01m"
COLOR_RED = "\033[101m"
TEXT_COLOR_RESET = "\x1b[0m"
BG_COLOR_RESET = "\e[0m"

ENVIRONMENT ?= ""
BACKUP_FILE ?= ./backup.tar.gz

help:
	@printf "Usage commands:\n"
	@printf "  make <command>\n"
	@printf "\n"
	@printf "Environment variables:\n"
	@printf "  ENVIRONMENT=<all|build|gateway|staging|production>\n"
	@printf "  BACKUP_FILE=<filename> (file must be present in backups directory)\n"
	@printf "  K3S_TOKEN=<token>\n"
	@printf "  K3S_SERVER_URL=<token>\n"
	@printf "\n"
	@printf "Examples:\n"
	@printf "  ENVIRONMENT=all make os-upgrade\n"
	@printf "  ENVIRONMENT=production make os-upgrade\n"
	@printf "  ENVIRONMENT=staging make k3s-backup\n"
	@printf "  ENVIRONMENT=staging BACKUP_FILE=backup.tar.gz make k3s-restore\n"
	@printf "  ENVIRONMENT=staging make k3s-install-server\n"
	@printf "  ENVIRONMENT=staging K3S_TOKEN=<token> K3S_SERVER_URL='https://master:6433' make k3s-install-agents\n"
	@printf "\n"
	@printf "Available commands:\n"
	@awk 'match($$0, /^(\w+-?\w+-?\w+): .* ## (.*)/, m) {printf "  %s%-25s%s%s\n", ${COLOR_GREEN}, m[1], ${TEXT_COLOR_RESET}, m[2]}' ${MAKEFILE_LIST}
	@printf "\n"

default: help

validate-environment:
	@[ ! -z "${ENVIRONMENT}" ] || (printf "%s%b%s%b\n" "==> " ${COLOR_RED} "ENVIRONMENT variable is not set!" ${BG_COLOR_RESET} && exit 1)

validate-backup-file:
	@[ ! -z "${BACKUP_FILE}" ] || (printf "%s%b%s%b\n" "==> " ${COLOR_RED} "BACKUP_FILE variable is not set!" ${BG_COLOR_RESET} && exit 1)

validate-k3s-server-url:
	@[ ! -z "${K3S_SERVER_URL}" ] || (printf "%s%b%s%b\n" "==> " ${COLOR_RED} "K3S_SERVER_URL variable is not set!" ${BG_COLOR_RESET} && exit 1)

validate-k3s-token:
	@[ ! -z "${K3S_TOKEN}" ] || (printf "%s%b%s%b\n" "==> " ${COLOR_RED} "K3S_TOKEN variable is not set!" ${BG_COLOR_RESET} && exit 1)

ansible:
	@which ansible > /dev/null || (printf "%s%b%s%b\n" "==> " ${COLOR_RED} "ansible is not installed!" ${BG_COLOR_RESET} && exit 1)

ansible-playbook:
	@which ansible-playbook > /dev/null || (printf "%s%b%s%b\n" "==> " ${COLOR_RED} "ansible-playbook is not installed!" ${BG_COLOR_RESET} && exit 1)

ping: validate-environment ansible ## Pings all hosts
	@if [ "${ENVIRONMENT}" = "all" ]; then \
		for env in `ls inventories | sed -e "s/.yaml//" | xargs`; do \
			ansible -i inventories/$$env.yaml all -m ping; \
		done; \
	else \
		ansible -i inventories/${ENVIRONMENT}.yaml all -m ping; \
	fi

os-upgrade: validate-environment ansible-playbook ## Upgrades OS on all hosts
	@if [ "${ENVIRONMENT}" = "all" ]; then \
		for env in `ls inventories | sed -e "s/.yaml//" | xargs`; do \
			echo "==> Upgrading the operation system on $$env servers..."; \
			ansible-playbook --ask-become-pass -i inventories/$$env.yaml playbooks/os_upgrades.yaml; \
		done; \
	else \
		ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/os_upgrades.yaml; \
	fi

k3s-clean: validate-environment ansible-playbook ## Cleanups dangling container images on all hosts
	@if [ "${ENVIRONMENT}" = "all" ]; then \
		for env in `ls inventories | sed -e "s/.yaml//" | xargs`; do \
			echo "==> Cleaning k3s servers from dangling container images on $$env..."; \
			ansible-playbook --ask-become-pass -i inventories/$$env.yaml playbooks/k3s_clean.yaml; \
		done; \
	else \
		ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_clean.yaml; \
	fi

k3s-backup: validate-environment ansible-playbook ## Creates a backup file for k3s cluster's files and data
	@if [ "${ENVIRONMENT}" = "all" ]; then printf "%s%b%s%b\n" "==> " ${COLOR_RED} "ENVIRONMENT=all Not implemented!" ${BG_COLOR_RESET}; exit 1; fi
	@echo "==> Creating a backup of k3s server on ${ENVIRONMENT}..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_backup.yaml --extra-vars="env=${ENVIRONMENT}"

k3s-restore: validate-environment validate-backup-file ansible-playbook ## Restores the k3s cluster from a given backup file
	@if [ "${ENVIRONMENT}" = "all" ]; then printf "%s%b%s%b\n" "==> " ${COLOR_RED} "ENVIRONMENT=all Not implemented!" ${BG_COLOR_RESET}; exit 1; fi
	@echo "==> Restoring k3s server from a backup file on ${ENVIRONMENT}..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_restore.yaml --extra-vars="env=${ENVIRONMENT} backup_file=${BACKUP_FILE}"

k3s-install-server: validate-environment ansible-playbook ## Installs the k3s server
	@if [ "${ENVIRONMENT}" = "all" ]; then printf "%s%b%s%b\n" "==> " ${COLOR_RED} "ENVIRONMENT=all Not implemented!" ${BG_COLOR_RESET}; exit 1; fi
	@echo "==> Installing k3s server on ${ENVIRONMENT}..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_install_server.yaml --extra-vars="env=${ENVIRONMENT}"

k3s-install-agents: validate-environment validate-k3s-server-url validate-k3s-token ansible-playbook ## Installs the k3s agent on all worker nodes
	@if [ "${ENVIRONMENT}" = "all" ]; then printf "%s%b%s%b\n" "==> " ${COLOR_RED} "ENVIRONMENT=all Not implemented!" ${BG_COLOR_RESET}; exit 1; fi
	@echo "==> Installing k3s agent on ${ENVIRONMENT}..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_install_agent.yaml --extra-vars="env=${ENVIRONMENT} k3s_server_url=${K3S_SERVER_URL} k3s_token=${K3S_TOKEN}"

.PHONY: help default validate-environment validate-backup-file validate-k3s-server-url validate-k3s-token ansible ansible-playbook ping os-upgrade k3s-clean k3s-backup k3s-restore k3s-install-server k3s-install-agents
