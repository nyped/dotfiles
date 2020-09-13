#!/bin/env zsh

while :; do
	if iwctl station wlan0 show | tr -s ' ' | grep "State connected" >/dev/null 2>&1; then
		echo "直"
	else
		echo "睊"
	fi
	sleep 10
done
