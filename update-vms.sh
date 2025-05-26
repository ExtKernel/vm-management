#!/bin/bash
RHEL_UPDATE_COMMAND="sudo dnf update -y && sudo dnf upgrade -y"
DEBIAN_UPDATE_COMMAND="sudo apt-get update -y && sudo apt-get upgrade -y"
BOLD_GREEN="\033[1;32m"
NC="\033[0m"
USER=$1
MACHINES=$2
MODE=$3

function help() {
	echo -e "Usage: ./update-vms.sh <ssh-user> <machines-file> <mode>\nWhere <ssh-user> is the user that will be used for ssh command\n<machines-file> is a file that contains IPs or FQDNs of the VMs. Each on a newline\n<mode> accepts only \"reboot\" at the moment. Specifying it will make the VMs reboot after update"
}

function check_args() {
	if [[ -z $USER ]] || [[ -z $MACHINES ]]; then
		help
		exit 1
	fi

	if [[ -n $MODE ]]; then
        	if [[ "$MODE" == "reboot" ]]; then
                	RHEL_UPDATE_COMMAND="$RHEL_UPDATE_COMMAND; sudo reboot"
                	UBUNTU_UPDATE_COMMAND="$UBUNTU_UPDATE_COMMAND; sudo reboot"
        	else
                	help
                	exit 1
        	fi
	fi
}

function update() {
	while IFS=";" read address os; do
		ssh_command="ssh $USER@$address"
		echo $ssh_command

		case $os in
			"RHEL")
			        echo -e "${BOLD_GREEN}Updating RHEL VM with address $address${NC}\n\n\n"
			        $ssh_command "$RHEL_UPDATE_COMMAND" < /dev/null
			        echo -e "\n\n\n"
				;;
			"DEBIAN")
			        echo -e "${BOLD_GREEN}Updating Debian VM with address $address${NC}\n\n\n"
			        $ssh_command "$DEBIAN_UPDATE_COMMAND" < /dev/null
			        echo -e "\n\n\n"
				;;
		esac
	done < "$MACHINES"
}

check_args
update

