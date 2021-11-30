#!/usr/bin/env bash

id=$(bspc query -N -n .local.focused)
n=$(xprop WM_CLASS -id $id) n=${n#*, \"} n=${n%\"}
. <(~/dotfiles/bspwm/external_rules.sh _ "$n")
bspc node -d $desktop
