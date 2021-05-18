#!/bin/zsh

export XDG_SESSION_TYPE=x11 GDK_BACKEND=x11
dunst >/dev/null 2>&1 &!
picom --config ~/dotfiles/X/picom.conf -b --experimental-backend
systemctl --user import-environment DISPLAY
xrdb -merge ~/.Xresources
xset s off
xset s noblank
xbindkeys &!
setxkbmap \
	-layout us \
	-option ctrl:swap_lwin_lctl \
	-option caps:none \
	-option compose:ralt \
	-option ctrl:menu_rctrl
xmodmap \
	-e "clear Lock" \
	-e "keycode 0x42 = BackSpace BackSpace BackSpace"
exec bspwm
