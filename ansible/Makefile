
COLOR_GREEN = "\x1b[32;01m"
COLOR_RESET = "\x1b[0m"

ENVIRONMENT ?= staging
BACKUP_FILE ?= ./backup.tar.gz

help:
	@printf "Usage commands:\n"
	@printf "  make <command>\n"
	@printf "\n"
	@printf "Environment variables:\n"
	@printf "  ENVIRONMENT=<build|gateway|staging|production> Default: staging\n"
	@printf "  BACKUP_FILE=<path> Default: ./backup.tar.gz\n"
	@printf "\n"
	@printf "Examples:\n"
	@printf "  ENVIRONMENT=staging make os-upgrade\n"
	@printf "  ENVIRONMENT=production make os-upgrade\n"
	@printf "  ENVIRONMENT=staging BACKUP_FILE=./backup.tar.gz make k3s-restore\n"
	@printf "\n"
	@printf "Available commands:\n"
	@awk 'match($$0, /^(\w+-?\w+): .* ## (.*)/, m) {printf "  %s%-15s%s%s\n", ${COLOR_GREEN}, m[1], ${COLOR_RESET}, m[2]}' ${MAKEFILE_LIST}
	@printf "\n"

default: help

ansible:
	@which ansible > /dev/null || (echo "ansible not installed!" && exit 1)

ansible-playbook:
	@which ansible-playbook > /dev/null || (echo "ansible-playbook not installed!" && exit 1)

ping: ansible ## Pings all hosts
	@ansible -i inventories/${ENVIRONMENT}.yaml all -m ping

os-upgrade: ansible-playbook ## Upgrades OS on all hosts
	@echo "==> Upgrading the operation system on ${ENVIRONMENT} servers..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/os_upgrades.yaml

k3s-clean: ansible-playbook ## Cleanup dangling container images on all hosts
	@echo "==> Cleaning k3s servers from dangling container images on ${ENVIRONMENT}..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_clean.yaml

k3s-backup: ansible-playbook ## Creates a backup file for k3s cluster's files and data
	@echo "==> Creating a backup of k3s server on ${ENVIRONMENT}..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_backup.yaml --extra-vars="env=${ENVIRONMENT}"

k3s-restore: ansible-playbook ## Restores the k3s cluster from a given backup file
	@echo "==> Restoring k3s server from a backup file on ${ENVIRONMENT}..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_restore.yaml --extra-vars="env=${ENVIRONMENT} backup_file=${BACKUP_FILE}"

.PHONY: help default ansible ansible-playbook ping os-upgrade k3s-clean k3s-backup k3s-restore
