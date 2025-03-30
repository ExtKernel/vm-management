#!/bin/bash

START_STOP_SCRIPT_LOCATION="/home/exkernel/code/test-vm-management"
START_SCRIPT="$START_STOP_SCRIPT_LOCATION/start-vms.sh"
STOP_SCRIPT="$START_STOP_SCRIPT_LOCATION/stop-vms.sh"

case $1 in
	"start")
		$START_SCRIPT;;
	"stop")
		$STOP_SCRIPT;;
	*)
		echo "Use either \"start\" or \"stop\" as an option"
		exit 1;;
esac
