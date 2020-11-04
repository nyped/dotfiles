#!/usr/bin/env sh

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -c ~/.config/polybar/config.ini right &
# symlink to hide the bar
ln -sf /tmp/polybar_mqueue.$(pidof -x polybar) /tmp/right-ipc
polybar -c ~/.config/polybar/config.ini left &
polybar -c ~/.config/polybar/config.ini center &
