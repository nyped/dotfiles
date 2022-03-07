#!/usr/bin/env bash

readonly pan_cmd="eww windows | grep \* && eww close-all || eww open panel_right || eww open panel_left"
monitors=($(xrandr --listactivemonitors | awk '{print $4}'))

killall polybar

_() { # $1 in monitors?
  case "${monitors[@]}" in *"$1"*);; *) return 1;; esac
}

_ HDMI-1 && \
  MONITOR=HDMI-1 PAN_CMD="$pan_cmd" polybar -c ~/.config/polybar/config.ini right  &
_ eDP-1 && \
  MONITOR=eDP-1  polybar -c ~/.config/polybar/config.ini laptop &
_ LVDS-1 && \
  MONITOR=LVDS-1 polybar -c ~/.config/polybar/config.ini laptop &

disown -a

# vim:set ts=2 sts=2 sw=2 et:
