START_OPTION=$1

if [[ -z "$START_OPTION" ]]; then
	echo -e "Please, specify a positional argument. Acceptable values: \"ALL\", \"NET\""
	exit 1
fi

function mount_drives {
	# change according to your setup
	# or don't call at all, if not needed
	SSD_TO_MOUNT="/dev/sdb1"
	HDD_TO_MOUNT="/dev/sda1"

	echo "Mounting all necessary drives..."
	sudo udisksctl mount -b $SSD_TO_MOUNT
	sudo udisksctl mount -b $HDD_TO_MOUNT
}

function start_vms {
	if [[ "$START_OPTION" == "NET" ]]; then
		GREEN="\033[0;32m"
		RESET="\033[0m"
		echo -e "Starting primary ${GREEN}DHCP${RESET} and ${GREEN}DNS${RESET} servers"
		sudo virsh start "dhcp01"
		sudo virsh start "dns01"
	else
		ALL_INACTIVE=$(sudo virsh list --inactive)
		FORMATTED_LIST=$(echo "$ALL_INACTIVE" | tail -n +3 | awk '{print $2}' | grep -v "^$")
		echo "Starting all inactive VMs..."
		while read -r line 
		do 
        		sudo virsh start "$line"
		done <<< $FORMATTED_LIST
	fi
}

mount_drives
start_vms
