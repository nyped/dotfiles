#!/usr/bin/env bash

while true; do
	echo " $(cat /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:96/APP0001:00/temp10_input| sed 's/000//')°C"
	sleep 10
done
