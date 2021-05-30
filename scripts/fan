#!/bin/bash

hwmon=/sys/devices/platform/applesmc.768

toggle() {
	local tmp
	[[ $(< ${hwmon}/fan1_manual) = 1 ]] && tmp=0
	echo ${tmp:-1} | tee ${hwmon}/fan1_manual
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
		[[ $(< ${hwmon}/fan1_manual) != 1 ]] && echo 1 > ${hwmon}/fan1_manual
		echo ${1/k/000} > ${hwmon}/fan1_output
		;;
esac
