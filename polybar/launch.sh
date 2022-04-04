#!/usr/bin/env bash

monitors=($(xrandr --listactivemonitors | awk '{print $4}'))

polybar-msg cmd quit
while pgrep -x polybar; do sleep .5; done

for mon in ${monitors[@]}; do
  case $mon in
    eDP* | LVDS*)
      target=laptop;;

    HDMI*)
      target=right;;
  esac

  MONITOR=$mon polybar -c ~/.config/polybar/config.ini $target  &
done

disown -a

# vim:set ts=2 sts=2 sw=2 et:
