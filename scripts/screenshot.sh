#!/bin/bash
#
# quick scrots
# https://thurlow.io/linux/2017/11/10/replicating-macos-screenshot-utility-on-linux.html

function usage() {
cat <<EOF >&2
Usage: ${1##*/} <cmd>
Available commands:
-w	--windows	capture the focused window
-a	--all		capture the whole screen
-s	--select	capture the selected part
EOF
}

name=~/Screenshots/$(date +%F-%H:%M:%S-screenshot)
flags="-border -quality 0 "

case $1 in
	-w | --windows)
		flags+="-windows $(bspc query -N -n .local.focused)"
		;;

	-a | --all)
		flags+="-windows root"
		;;

	-s | --select)
		:
		;;

	*)
		usage $0 && exit 1
		;;
esac

import $flags ${name}.xwd
convert ${name}.xwd \( +clone -background black -shadow 60x10+0+10 \) +swap -background transparent -layers merge +repage  -quality 0 ${name}.png
rm ${name}.xwd

notify-send Screenshot "saved as ${name##*/}.jpg"
