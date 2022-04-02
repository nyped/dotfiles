#!/usr/bin/env bash

monitors=($(xrandr --listactivemonitors | awk '{print $4}'))

killall -q polybar

on() { # $1 in monitors?
  case "${monitors[@]}" in *"$1"*);; *) return 1;; esac
}

on HDMI-1 && \
  MONITOR=HDMI-1 polybar -r -c ~/.config/polybar/config.ini right  &
on eDP-1 && \
  MONITOR=eDP-1  polybar -r -c ~/.config/polybar/config.ini laptop &
on LVDS-1 && \
  MONITOR=LVDS-1 polybar -r -c ~/.config/polybar/config.ini laptop &

disown -a

# vim:set ts=2 sts=2 sw=2 et:
