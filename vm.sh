#!/bin/bash
START_OPTION="ALL"
START_STOP_SCRIPT_LOCATION="/home/exkernel/code/test-vm-management"
START_SCRIPT="$START_STOP_SCRIPT_LOCATION/start-vms.sh"
STOP_SCRIPT="$START_STOP_SCRIPT_LOCATION/stop-vms.sh"

if [[ -n $2 ]]; then
	if [[ "$2" == "NET" ]]; then
		START_OPTION="NET"
	else
		echo -e "If you're trying to start only network-related VMs, please specify \"NET\" positional argument, instead of $1. If you're not, then run the script without any arguments"
		exit 1
	fi
fi

case $1 in
	"start")
		$START_SCRIPT $START_OPTION;;
	"stop")
		$STOP_SCRIPT;;
	*|help)
		echo -e "Use either \"start\" or \"stop\" as a first positional argument.\nWhen using \"start\", you can also add a second positional argument \"ALL\"(to start all VMs) or \"NET\"(to start only network-related VMs). Example: ./vm.sh start NET"
		exit 1;;
esac
