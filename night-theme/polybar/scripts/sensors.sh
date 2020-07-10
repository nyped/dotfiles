#!/usr/bin/env bash

while true; do
	echo " $(cat /sys/devices/platform/applesmc.768//fan1_input) RPM"
	sleep 10
done
