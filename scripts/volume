#!/bin/bash

function update() {
	pactl set-sink-volume @DEFAULT_SINK@ ${1:-+5}%
	notify-send Volume "Set to $(pactl list sinks | grep -m 1 \%\ \/ | cut -d \/ -f 2 | sed s/\ //g)" -h string:x-canonical-private-synchronous:anything -a notif
}

if [[ $1 = toggle ]]; then
	pactl set-sink-mute @DEFAULT_SINK@ toggle
else
	update $1
fi
