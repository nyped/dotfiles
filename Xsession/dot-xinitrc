#!/usr/bin/env zsh

export XDG_SESSION_TYPE=x11 GDK_BACKEND=x11
picom --config ~/.config/picom/picom.conf -b --experimental-backend
systemctl --user import-environment DISPLAY XAUTHORITY
xrdb -merge ~/.Xresources
xset s off
xset s noblank
xbindkeys &

# setting keyboard layout
if [[ $HOST == iron ]]; then
	~/bin/keyboard -e
else
	~/bin/keyboard -m
fi

exec awesome
