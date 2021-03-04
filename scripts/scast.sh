#!/bin/bash

# kill other instances
a="$(pidof ffmpeg)"
if [ -n "$a" ]; then
	kill $a
	echo Screencast stopped
	exit 0
fi

cd ~/Videos
name=$(date "+%Y-%m-%d-%H.%M.%S-screencast.mp4")

if [ "$1" = "-s" ]; then # with sound
	ffmpeg -f x11grab -video_size 1440x900 -framerate 60 -i $DISPLAY -f pulse -i alsa_input.pci-0000_00_1b.0.analog-stereo -ac 1 -c:v libx264 -preset ultrafast -c:a aac $name >/dev/null 2>&1 &
	echo Screencast with sound
else # no sound
	ffmpeg -f x11grab -video_size 1440x900 -framerate 60 -i $DISPLAY -c:v libx264 -preset ultrafast -c:a aac $name >/dev/null 2>&1 &
	echo Screencast with no sound
fi

disown
