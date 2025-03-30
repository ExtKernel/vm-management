function mount_drives {
	SSD_TO_MOUNT="/dev/sdb1"
	HDD_TO_MOUNT="/dev/sda1"

	echo "Mounting all necessary drives..."
	sudo udisksctl mount -b $SSD_TO_MOUNT
	sudo udisksctl mount -b $HDD_TO_MOUNT
}

function start_vms {
	ALL_INACTIVE=$(sudo virsh list --inactive)
	FORMATTED_LIST=$(echo "$ALL_INACTIVE" | tail -n +3 | awk '{print $2}' | grep -v "^$")
	
	echo "Starting all inactive VMs..."
	while read -r line 
	do 
        	sudo virsh start "$line"
	done <<< $FORMATTED_LIST
}

mount_drives
start_vms
