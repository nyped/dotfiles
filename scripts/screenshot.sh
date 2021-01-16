#!/bin/bash
#
# quick scrots

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
		scrot -q 100 -u -b ~/Screenshots/%y-%m-%d-%T-screenshot.png -e 'convert $f  \\( +clone -background black -shadow 60x10+0+10 \\) +swap -background transparent -layers merge +repage -quality 100 $f'
# https://thurlow.io/linux/2017/11/10/replicating-macos-screenshot-utility-on-linux.html
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
