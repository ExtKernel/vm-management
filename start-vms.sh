START_OPTION=$1
DRIVES=$2

function help {
	echo -e "Please, specify positional arguments.\nUsage: ./start-vms.sh <mode> <drives> 

	mode: \"ALL\" - will start all of the VMs that virsh can see
       	      \"NET\" - will start VMs that are named \"dhcp01\" and \"dns01\"
	      </path/to/the/machines/file.cfg> - path to the machines file. The machines file should look like this:
			name-of-the-vm
			another-name-of-the-another-vm
			...
	drives (optional): if there're drives to be mounted in order to start the VMs, please specify name(path) of the file that contains:
			<drive>;<mount-directory>
			<another-drive>;<another-mount-directory>
			...
	"
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
