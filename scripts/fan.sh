#!/bin/bash

toggle() {
	local tmp
	[[ $(cat /sys/devices/platform/applesmc.768/fan1_manual) = 1 ]] && tmp=0
	echo ${tmp:-1} | tee /sys/devices/platform/applesmc.768/fan1_manual 2>/dev/null 1>&2

}

case $1 in
	toggle)
		toggle
		;;
	"")
		echo usage: fan \<toggle\|speed\> 1>&2
		exit 1
		;;
	*)
		echo $1 | tee /sys/devices/platform/applesmc.768/fan1_output
		;;
esac
