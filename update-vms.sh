#!/bin/bash
RHEL_UPDATE_COMMAND="sudo dnf update -y && sudo dnf upgrade -y"
UBUNTU_UPDATE_COMMAND="sudo apt-get update -y && sudo apt-get upgrade -y"
BOLD_GREEN="\033[1;32m"
NC="\033[0m"
MODE=$1

if [[ -n $MODE ]]; then
	if [[ "$MODE" == "reboot" ]]; then
		RHEL_UPDATE_COMMAND="$RHEL_UPDATE_COMMAND; sudo reboot"
		UBUNTU_UPDATE_COMMAND="$UBUNTU_UPDATE_COMMAND; sudo reboot"
	else
		echo -e "Currently the following update modes are available: \"reboot\""
		exit 1
	fi
fi

# Update Basic net infra VMs
echo -e "$BOLD_GREEN Updating DHCP VM server\n $NC"
ssh root@10.1.1.2 "$UBUNTU_UPDATE_COMMAND" &

echo -e "$BOLD_GREEN Updating DNS VM server\n $NC" &
ssh root@10.1.1.3 "$RHEL_UPDATE_COMMAND"

# Update Provisioning VMs
echo -e "$BOLD_GREEN Updating Ansible VM server\n $NC" &
ssh root@10.1.2.10 "$RHEL_UPDATE_COMMAND"

echo -e "$BOLD_GREEN Updating MAAS VM server\n $NC" &
ssh root@10.1.2.11 "$UBUNTU_UPDATE_COMMAND"

# Update IDP VMs
echo -e "$BOLD_GREEN Updating Keycloak VM server\n $NC" &
ssh root@10.1.3.10 "$RHEL_UPDATE_COMMAND"

echo -e "$BOLD_GREEN Updating FreeIPA VM server\n $NC" &
ssh root@10.1.3.11 "$RHEL_UPDATE_COMMAND"

# Update Software VMs
echo -e "$BOLD_GREEN Updating IDP Sync VM server\n $NC" &
ssh root@10.1.4.10 "$RHEL_UPDATE_COMMAND"

echo -e "$BOLD_GREEN Updating DBs VM server\n $NC" &
ssh root@10.1.4.20 "$RHEL_UPDATE_COMMAND"

# Update Purely test VMs
# --- Can not update Windows 11 from here

wait
