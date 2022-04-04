#!/usr/bin/env bash
#
# deps: xdo

id="$1"
class="$2"
instance="$3"

# Windows spawn in the focused monitor
[[ "$(bspc query -M -m .focused --names)" == HDMI* && "$(bspc query -M --names | wc -l)" > 1 ]] && _PREF=1 || _PREF=""

case "$class" in
  [rR][sS]tudio)
    echo desktop=^${_PREF}2
    ;;

  *office*)
    echo desktop=^${_PREF}8
    ;;

  discord)
    echo desktop=^${_PREF}5 state=pseudo_tiled
    ;;

  Xephyr)
    echo focus=off
    ;;

  firefox)
    echo desktop=^${_PREF}1 follow=off state=pseudo_tiled
    ;;

  Gimp)
    echo desktop=^${_PREF}7 follow=off
    ;;

  qBittorrent)
    echo desktop=^${_PREF}10 follow=off
    ;;

  terminal)
    echo state=floating rectangle=524x297+900+580 sticky=true
    ;;

  Terminal)
    echo desktop=^${_PREF}3 follow=off
    ;;

  vlc)
    echo desktop=^${_PREF}6 follow=off
    ;;

  Vlc)
    echo desktop=^${_PREF}6 follow=off
    ;;

  Zathura)
    echo desktop=^${_PREF}4 follow=off
    ;;

  zoom)
    echo desktop=^${_PREF}7 follow=off
    ;;

  Spyder)
    echo desktop=^${_PREF}2 follow=off state=pseudo_tiled
    ;;

  java-lang-Thread) # maple
    echo desktop=^${_PREF}2 follow=off state=floating
    ;;

  Spotify)
    echo desktop=^${_PREF}9
    ;;

  Network\ Helper)
    echo state=floating
    ;;

  Pdfpc) # Fullscreen presentation on desktop 7
    case $(xprop WM_ICON_NAME -id $id) in
      *presenter*)
        echo desktop=^7 state=fullscreen follow=on focus=on
      ;;

      *presentation*)
        echo desktop=^17 state=fullscreen follow=on
      ;;
    esac
    ;;

  *)
    :
    ;;
esac


# from here, handling empty wm_class
case "$class" in ""|" ");; *) exit 0; esac

owner="$(ps -p "$(xdo pid "$id")" -o comm= 2>/dev/null)"

case "$owner" in
  spotify)
    echo desktop=^${_PREF}9 follow=off state=pseudo_tiled
    ;;

  python)
    echo state=floating focus=off
    ;;
esac

# vim:set ts=8 sts=2 sw=2 et:
