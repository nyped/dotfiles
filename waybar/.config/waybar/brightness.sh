#!/usr/bin/env bash
# brightness

mon="$(swaymsg -t get_tree | jq -r '.nodes[] | select([recurse(.nodes[]?, .floating_nodes[]?) | .focused] | any) | .name')"

case "$mon" in
  eDP-1) # internal
    if [[ $1 == backlight ]]; then
      # shellcheck disable=SC2086
      ~/bin/backlight -l -n $2
    else
      : # not implemented
    fi
    ;;

  *) # external
    if [[ $1 == backlight ]]; then
      # shellcheck disable=SC2086
      ~/bin/backlight -m -n $2
    else
      # shellcheck disable=SC2086
      ~/bin/backlight -m -n -b $2
    fi
    ;;
esac

# vim:set ts=8 sts=2 sw=2 et:
