#!/usr/bin/env bash
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
-S  --shadows      capture macos like shadows
EOF
}

name="${HOME}/Screenshots/$(date +%F-%Hh%Mm%Ss-screenshot)"
flags="-border -quality 0 "

while [[ -n "$1" ]]; do
	case "$1" in
		-w | --windows)
			flags+="-windows $(bspc query -N -n .local.focused)"
			;;

		-a | --all)
			flags+="-windows root"
			;;

		-s | --select)
			:
			;;

		-S | --shadows)
			SHAD=1
			;;

		*)
			usage $0 && exit 1
		;;
	esac

	shift
done

import $flags "${name}.xwd"

if [[ "${SHAD}" == 1 ]];
	then convert "${name}.xwd" \( +clone -background black -shadow 60x10+0+10 \) +swap -background transparent -layers merge +repage  -quality 0 "${name}.png"
	else convert "${name}.xwd" "${name}.jpg"
fi
rm "${name}.xwd"

notify-send Screenshot "saved as ${name##*/}.jpg"
