#!/bin/zsh

function usage() {
echo "\
Usage: screen <cmd>
Available commands:
-w	--windows	capture the focused window
-a	--all		capture the whole screen
"
}

name=$(date "+%Y-%m-%d-%T-screenshot")
cd ~/Pictures

case $1 in
	-w | --windows)
		sleep 0.5
		xwininfo > screen &
		sleep 1
		xdotool click 1 > /dev/null
		id=$( cat screen | grep 'id:' | cut -d ' ' -f 4)
		xwd -id $id -frame -out ${name}.xwd
		convert ${name}.xwd ${name}.png
		rm ${name}.xwd screen 2>/dev/null
		;;
	-a | -all)
		scrot -b ~/Pictures/%Y-%m-%d-%T-screenshot.png
		;;
	*)
		usage && exit 1
		;;
esac
