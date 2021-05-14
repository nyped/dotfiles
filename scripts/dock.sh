#!/usr/bin/env bash
# dock laptop
# Fri Apr 30 06:51:09 PM CEST 2021
# lennypeers

monitors=($(bspc query -M --names | sort))

if [[ -z "$1" ]]; then
  xrandr --output "${monitors[0]}" --off --output "${monitors[1]:-HDMI-1}" --auto --primary --delmonitor "${monitors[0]}" &>/dev/null
else
  xrandr --output "${monitors[0]}" --auto --primary --output "${monitors[1]:-HDMI-}" --auto --right-of "${monitors[0]}" &>/dev/null
fi

THEME=$(< ~/.t)
~/dotfiles/polybar/launch.sh &>/dev/null
hsetroot -cover ~/dotfiles/wallpaper/"${THEME:-day}".png &>/dev/null

# vim:set ts=8 sts=2 sw=2 et:
