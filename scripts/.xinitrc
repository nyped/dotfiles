#!/bin/zsh

export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
xrdb -merge ~/.Xresources
picom --config ~/dotfiles/X/picom.conf -b --experimental-backend
xbindkeys
systemctl --user import-environment DISPLAY
dunst &!
exec bspwm
