function unmount_drives {
	SSD_TO_UNMOUNT="/dev/sdb1"
	HDD_TO_UNMOUNT="/dev/sda1"

	echo "Unmounting necessary for VMs drives"
	sudo udisksctl unmount -b $SSD_TO_UNMOUNT
	sudo udisksctl unmount -b $HDD_TO_UNMOUNT
}

function stop_vms {
	ALL_ACTIVE=$(sudo virsh list --state-running)
	FORMATTED_LIST=$(echo "$ALL_ACTIVE" | tail -n +3 | awk '{print $2}' | grep -v "^$")

	echo "Stopping all active VMs..."
	while read -r line
	do
    		sudo virsh shutdown "$line"
	done <<< "$FORMATTED_LIST"
}

stop_vms

sleep 20
unmount_drives

