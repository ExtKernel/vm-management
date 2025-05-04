function handle_unmount_error {
        while [ $? != 0 ]; do
		increment=$(($increment + 1))
		if [[ $increment > 3 ]]; then
			stop_vms "destroy"
		fi

		echo -e "Retry in 5 seconds\n"
                sleep 5s
		$SSD_UNMOUNT_COMMAND
        done
}

function unmount_drives {
        # change according to your setup
        # or don't call at all, if not needed
        SSD_LABEL="ssd-storage0"
	SSD_MOUNT_DIR="/mnt/$SSD_LABEL"
#       HDD_LABEL="lgt-storage0"
#       HDD_MOUNT_DIR="/mnt/$HDD_LABEL"

        echo -e "Unmounting all VM drives..."
	echo -e "Unmounting $SSD_LABEL from $SSD_MOUNT_DIR"
        sudo umount "$SSD_MOUNT_DIR"
	handle_unmount_error
#        echo -e "Unmounting $SSD_LABEL from $HDD_MOUNT_DIR"  
#        sudo umount "$HDD_MOUNT_DIR"   
	handle_unmount_error
}


function stop_vms {
	ALL_ACTIVE=$(sudo virsh list --state-running)
	FORMATTED_LIST=$(echo "$ALL_ACTIVE" | tail -n +3 | awk '{print $2}' | grep -v "^$")

	if [[ -n $1 ]]; then
		if [[ "$1" == "destroy" ]]; then
			STOP_METHOD="$1"
		fi
	else
		STOP_METHOD="shutdown"
	fi

	echo "Stopping all active VMs..."
	while read -r line
	do
    		sudo virsh $STOP_METHOD "$line"
	done <<< "$FORMATTED_LIST"
}

stop_vms
sleep 5s
unmount_drives

