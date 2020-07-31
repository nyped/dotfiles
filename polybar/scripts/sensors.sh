#!/usr/bin/env bash

while true; do
	[[ -f /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:96/APP0001:00/fan1_input ]] && \
	echo " $(cat /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:96/APP0001:00/fan1_input) RPM"
	sleep 10
done
