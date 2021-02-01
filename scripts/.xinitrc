#!/bin/zsh

export XDG_SESSION_TYPE=x11 GDK_BACKEND=x11
dunst >/dev/null 2>&1 &!
picom --config ~/dotfiles/X/picom.conf -b --experimental-backend
systemctl --user import-environment DISPLAY
xbindkeys
xrdb -merge ~/.Xresources
xset s off
xset s noblank
exec bspwm
