function handle_unmount_error {
        local exit_code=$1
        local increment=0
        while [ $exit_code != 0 ]; do
                increment=$(($increment + 1))
                if [[ $increment > 3 ]]; then
                        stop_vms "destroy"
                        break
                fi
                echo -e "Retry in 15 seconds\n"
                sleep 15s
                $SSD_UNMOUNT_COMMAND
                exit_code=$?
        done
}

function unmount_drive {
        DRIVE_LABEL=$1
        DRIVE_MOUNT_DIR=$2
        echo -e "Unmounting $DRIVE_LABEL from $DRIVE_MOUNT_DIR"
        sudo umount "$DRIVE_MOUNT_DIR"
        handle_unmount_error $?
}

function unmount_drives {
        # change according to your setup
        # or don't call at all, if not needed
        # SSD
        SSD_LABEL="ssd-storage0"
        SSD_MOUNT_DIR="/mnt/$SSD_LABEL"
        SSD_UNMOUNT_COMMAND="sudo umount $SSD_MOUNT_DIR"
        unmount_drive $SSD_LABEL $SSD_MOUNT_DIR
        # HDD
        HDD_LABEL="lgt-storage0"
        HDD_MOUNT_DIR="/mnt/$HDD_LABEL"
        SSD_UNMOUNT_COMMAND="sudo umount $HDD_MOUNT_DIR"  # Note: should probably be HDD_UNMOUNT_COMMAND
        unmount_drive $HDD_LABEL $HDD_MOUNT_DIR
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

