#!/bin/zsh

xrdb -merge ~/.Xresources
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
picom --experimental-backend --config ~/dotfiles/X/picom.conf -b
xbindkeys
dunst &!
exec bspwm
