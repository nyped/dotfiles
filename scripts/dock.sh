#!/usr/bin/env bash
# dock laptop
# Fri Apr 30 06:51:09 PM CEST 2021
# lennypeers

monitors=($(bspc query -M --names | sort))
# LVDS-1 is indexed 1. Gotta reverse it
[[ ${monitors[0]} == HDMI-1 ]] && monitors=($(bspc query -M --names | sort -r))


usage() {
    cat << _HELPTXT
usage: ${0##*/} [--help | -h] [--dock | -d] [--multi | -m]
_HELPTXT
}

case "$1" in
  -h | --help)
    usage
    exit 0
  ;;

  -d | --dock)
  # laptop monitor off (dock)
    xrandr --output "${monitors[0]}" --off --output "${monitors[1]:-HDMI-1}" --auto --primary --delmonitor "${monitors[0]}" &>/dev/null
  ;;

  -m | --multi)
  # multi head
    xrandr --output "${monitors[0]}" --auto --primary --output "${monitors[1]:-HDMI-1}" --auto --right-of "${monitors[0]}" &>/dev/null
  ;;

  *)
    usage
    exit 255
  ;;
esac

THEME=$(< ~/.t)
~/dotfiles/polybar/launch.sh &>/dev/null
hsetroot -cover ~/dotfiles/wallpaper/"${THEME:-day}".png &>/dev/null

# vim:set ts=8 sts=2 sw=2 et:
