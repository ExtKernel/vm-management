#!/bin/bash
START_OPTION=$2
DRIVES=$3
START_STOP_SCRIPT_LOCATION="/home/exkernel/code/test-vm-management"
START_SCRIPT="$START_STOP_SCRIPT_LOCATION/start-vms.sh"
STOP_SCRIPT="$START_STOP_SCRIPT_LOCATION/stop-vms.sh"

case $1 in
	"start")
		$START_SCRIPT "$START_OPTION" "$DRIVES"
		;;
	"stop")
		$STOP_SCRIPT
		;;
	"list")
		sudo virsh list --all
		;;
	*|help)
		echo -e "Use either \"start\" or \"stop\" as a first positional argument.\nWhen using \"start\", you can also add a second positional argument \"ALL\"(to start all VMs) or \"NET\"(to start only network-related VMs). Example: ./vm.sh start NET"
		exit 1
		;;
esac
