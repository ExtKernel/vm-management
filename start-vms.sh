START_OPTION=$1
DRIVES=$2

function help {
	echo -e "Please, specify a positional argument. Acceptable values: \"ALL\", \"NET\" or name of the file that contains names of the VMs to be started row by row"
}

if [[ -z "$START_OPTION" ]]; then
	help
	exit 1
fi

function mount_drive {
	DRIVE_TO_MOUNT=$1
	DRIVE_LABEL=$2

	echo -e "Making a mount directory if not exists"
	sudo mkdir -p "/mnt/$DRIVE_LABEL"
	echo -e "Mounting "$DRIVE_TO_MOUNT" at "/mnt/$DRIVE_LABEL""
	sudo mount "$DRIVE_TO_MOUNT" "/mnt/$DRIVE_LABEL"
}

function mount_drives {
	while IFS=";" read mount_dir mount_label; do
		mount_drive "$mount_dir" "$mount_label"

	done < "$DRIVES"	
}

function start_vms {
	if [[ "$START_OPTION" == "NET" ]]; then
		GREEN="\033[0;32m"
		RESET="\033[0m"
		echo -e "Starting primary ${GREEN}DHCP${RESET} and ${GREEN}DNS${RESET} servers"
		sudo virsh start "dhcp01"
		sudo virsh start "dns01"
	elif [[ "$START_OPTION" == "ALL" ]]; then
		ALL_INACTIVE=$(sudo virsh list --inactive)
		FORMATTED_LIST=$(echo "$ALL_INACTIVE" | tail -n +3 | awk '{print $2}' | grep -v "^$")
		echo "Starting all inactive VMs..."
		while read -r line 
		do 
        		sudo virsh start "$line"
		done <<< $FORMATTED_LIST
	else
		#MACHINES=$(find . -name "$START_OPTION")
		MACHINES="$START_OPTION"

		if [[ -z $MACHINES ]]; then
			help
			exit 1
		fi

		while read -r line; do
			sudo virsh start $line
		done < $MACHINES
	fi
}

mount_drives
start_vms
