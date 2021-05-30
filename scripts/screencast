#!/usr/bin/env bash

function notify() {
	notify-send "Screencast" "$1"
	exit ${2:-255}
}

# kill other instances of ffmpeg
a="$(pidof ffmpeg)"
if [[ -n "$a" ]]; then
	kill $a
	notify "Screencast stopped" 0
fi

cd ~/Videos
name=$(date "+%Y-%m-%d-%H.%M.%S-screencast.mp4")
dimensions=$(xdpyinfo | awk '/dimensions/{print $2}')

function help() {
	cat <<EOF
usage: ./${0##*/} [-hfs] [filename]
	-h --help   show help
	-f --force  overwrite output file
	-s --sound  record with sound
EOF
}

while [[ -n "$1" ]]; do
	case "$1" in
		-h | --help)
			help
			exit 255
			;;

		-s | --sound) # with sound
		flags+=" -f pulse"
		flags+=" -i alsa_input.pci-0000_00_1b.0.analog-stereo"
		flags+=" -ac 1"
		;;

		-f | --force) # overwrite
		force=" -y"
		;;

		*) # a filename ?
		[[ -n "$custom_name" ]] && \
			notify "Cannot parse the argument: $1"
		custom_name=1
		name="$1"
		;;
	esac
	shift
done

[[ -f "$name" && -z "$force" ]] && \
	notify "File exists" 254

ffmpeg \
	-framerate 60 \
	-f x11grab \
	-video_size $dimensions \
	-thread_queue_size 1024 \
	-i $DISPLAY \
	$flags \
	-c:v libx264 \
	-preset ultrafast \
	-c:a aac \
	$force \
	"$name" >/dev/null 2>&1 &
disown
notify "Screencast started" 0
