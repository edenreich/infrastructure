
ENVIRONMENT ?= staging
BACKUP_FILE ?= ./backup.tar.gz

help:
	@printf "Usage:\n"
	@printf " make <command>\n"
	@printf " ENVIRONMENT=<environment> make <command>\n\n"
	@printf "Envrionment Variables:\n"
	@printf " ENVIRONMENT=<environment>, default: staging\n"
	@printf " BACKUP_FILE=<path>, default: ./backup.tar.gz\n\n"
	@printf "Commands:\n"
	@printf " ping           Pings the servers\n"
	@printf " os-upgrade     Upgrades the operation system\n"
	@printf " k3s-clean      Cleanup dangling container images\n"
	@printf " k3s-backup     Creates a backup file for k3s cluster's files and data\n"
	@printf " k3s-restore    Restores the k3s cluster from a given backup file\n"

default: help

ansible:
	@which ansible > /dev/null || (echo "ansible not installed!" && exit 1)

ansible-playbook:
	@which ansible-playbook > /dev/null || (echo "ansible-playbook not installed!" && exit 1)

ping: ansible
	@ansible -i inventories/${ENVIRONMENT}.yaml all -m ping

os-upgrade: ansible-playbook
	@echo "==> Upgrading the operation system on ${ENVIRONMENT} servers..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/os_upgrades.yaml

k3s-clean: ansible-playbook
	@echo "==> Cleaning k3s servers from dangling container images on ${ENVIRONMENT}..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_clean.yaml

k3s-backup: ansible-playbook
	@echo "==> Creating a backup of k3s server on ${ENVIRONMENT}..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_backup.yaml --extra-vars="env=${ENVIRONMENT}"

k3s-restore: ansible-playbook
	@echo "==> Restoring k3s server from a backup file on ${ENVIRONMENT}..."
	@ansible-playbook --ask-become-pass -i inventories/${ENVIRONMENT}.yaml playbooks/k3s_restore.yaml --extra-vars="env=${ENVIRONMENT} backup_file=${BACKUP_FILE}"

.PHONY: help default ansible ansible-playbook ping os-upgrade k3s-clean k3s-backup k3s-restore
