#!/usr/bin/env bash

while true; do
	[[ -f /sys/devices/platform/applesmc.768//temp10_input ]] && \
	echo " $(cat /sys/devices/platform/applesmc.768//temp10_input| sed 's/000//')°C"
	sleep 10
done
