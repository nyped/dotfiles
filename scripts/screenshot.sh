#!/bin/zsh

function usage() {
echo "\
Usage: ${1##*/} <cmd>
Available commands:
-w	--windows	capture the focused window
-a	--all		capture the whole screen
-s	--select	capture the selected part
"
}

case $1 in
	-w | --windows)
		scrot -q 100 -u -b ~/Screenshots/%y-%m-%d-%T-screenshot.png
		;;
	-a | --all)
		scrot -q 100 -b ~/Screenshots/%y-%m-%d-%T-screenshot.png
		;;
	-s | --select)
		scrot -q 100 -b -s -l style=dash,width=3,color=red -f ~/Screenshots/%y-%m-%d-%T-screenshot.png
		;;
	*)
		usage $0 && exit 1
		;;
esac
