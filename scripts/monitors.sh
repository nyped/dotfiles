#!/usr/bin/env bash

monitors=($(xrandr --query | grep \ connected --color=never | cut -d \  -f 1 | sort))
# LVDS-1 is indexed 1. Gotta reverse it
[[ ${monitors[0]} == HDMI1 ]] && monitors=(${monitors[1]} ${monitors[0]})

usage() {
    cat << _HELPTXT
usage: ${0##*/} [--help | -h] [--dock | -d] [--multi | -m] [--laptop | -l]
_HELPTXT
}

case "$1" in
  -h | --help)
    usage
    exit 0
  ;;

  -d | --dock)
  # laptop monitor off (dock)
    xrandr --output "${monitors[0]}" --off --output "${monitors[1]:-HDMI1}" --auto &>/dev/null
  ;;

  -m | --multi)
  # multi head
    xrandr --output "${monitors[0]}" --auto --primary --output "${monitors[1]:-HDMI1}" --auto --right-of "${monitors[0]}" &>/dev/null
  ;;

  -l | --laptop)
  # laptop only
    xrandr --output "${monitors[1]:-HDMI1}" --off --output "${monitors[0]}" --auto &>/dev/null
  ;;

  *)
    usage
    exit 255
  ;;
esac

bspc wm -r

# vim:set ts=8 sts=2 sw=2 et:
