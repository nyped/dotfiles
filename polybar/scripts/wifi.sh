#!/bin/env zsh

while :; do
	if iwctl station wlan0 show | tr -s ' ' | grep "State connected" >/dev/null 2>&1; then
		echo "直$(iwctl station wlan0 show | sed -nr -e 's/^[ \t]*//' -e 's/\s*$//'  -e "s/Connected network  //p")"
	else
		echo "睊"
	fi
	sleep 10
done
