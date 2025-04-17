function handle_unmount_error {
        while [ $? != 0 ]; do
                sleep 5s
                $SSD_UNMOUNT_COMMAND
        done
}

function unmount_drives {
        # change according to your setup
        # or don't call at all, if not needed
	SSD_TO_UNMOUNT="/dev/sdb1"
	HDD_TO_UNMOUNT="/dev/sda1"
	SSD_UNMOUNT_COMMAND="sudo udisksctl unmount -b "$SSD_TO_UNMOUNT""
	HDD_UNMOUNT_COMMAND="sudo udisksctl unmount -b "$HDD_TO_UNMOUNT""

	echo "Unmounting necessary for VMs drives"
	$SSD_UNMOUNT_COMMAND	
	handle_unmount_error

	$HDD_UNMOUNT_COMMAND
	handle_unmount_error

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
unmount_drives

