#!/usr/bin/env bash
# mark

set -euo pipefail

menu=~/.config/sway/menu.sh

# getting the mark
m="$(swaymsg -t get_marks | jq -r '.[]' | $menu "$2")"
[[ -z $m ]] && exit

# action
case "$1" in
  toggle)
    swaymsg -- mark --toggle "$m"
    ;;

  focus)
    swaymsg -- "[con_mark=\"^$m\$\"]" focus
    ;;
esac

# update the decorations
swaymsg -- '[tiling]'        border pixel
swaymsg -- '[con_mark=".*"]' border normal

# vim:set ts=8 sts=2 sw=2 et:
