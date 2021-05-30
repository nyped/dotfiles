#!/bin/bash

# bspwm
# resize focused floating window to a predifined size
# deps: xorg-xwininfo

# add your sizes here (format: Width-Height)
# $1 is the index of the target size (default 0)
layouts=(524-297 650-436 644-729)
id=$(bspc query -N -n .local.focused.\!fullscreen)

{
read _ w
read _ h
} <<< $(xwininfo -id $id | grep 'Width\|Height')

IFS=- read wt ht <<< ${layouts[${1:-0}]:-${layouts[0]}}

bspc node $id -z right $(($wt-$w)) 0
bspc node $id -z bottom 0 $(($ht-$h))
