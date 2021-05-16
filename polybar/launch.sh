#!/usr/bin/env sh

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

monitors=($(bspc query -M --names | sort))
# LVDS-1 is indexed 1. Gotta reverse it
[[ ${monitors[0]} == HDMI-1 ]] && \
monitors=(${monitors[1]} ${monitors[0]})

[[ "${monitors[0]}" != HDMI-1 ]] && \
	MONITOR="${monitors[0]}" polybar -c ~/.config/polybar/config.ini laptop &
polybar -c ~/.config/polybar/config.ini right &

disown -a
