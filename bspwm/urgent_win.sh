#!/usr/bin/env bash
#
# set new windows to urgent
# https://github.com/baskerville/bspwm/issues/1115

bspc subscribe node_add | while read -a msg; do
  bspc query -D -d "${msg[2]}.!focused" > /dev/null \
    && xdotool set_window --urgency 1 "${msg[4]}"
done


# vim:set ts=8 sts=2 sw=2 et:
