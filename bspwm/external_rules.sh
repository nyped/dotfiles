#!/usr/bin/env bash
#
# deps: xdo

id="$1"
class="$2"
instance="$3"

# is it libreoffice ?
[[ "$instance" == *office* ]] && echo desktop=^8

# from here, handling empty wm_class
[[ -n "$class" ]] && exit 0

owner="$(ps -p "$(xdo pid "$id")" -o comm= 2>/dev/null)"

case "$owner" in
  spotify)
    echo desktop=^9 follow=off
    ;;

  *)
    ;;
esac

# vim:set ts=8 sts=2 sw=2 et:
