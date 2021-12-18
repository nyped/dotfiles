#!/usr/bin/env bash

killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

MONITOR=HDMI-1 polybar -c ~/.config/polybar/config.ini right  &
MONITOR=eDP-1  polybar -c ~/.config/polybar/config.ini laptop &
MONITOR=LVDS-1 polybar -c ~/.config/polybar/config.ini laptop &

disown -a
