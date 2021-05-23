#!/usr/bin/env bash

ret=$(
cat <<EOF | rofi -dmenu -i -p Do: -lines 4 -columns 4
Lock
Reboot
Shutdown
Suspend
Screen
Record
Theme
Music
Dock
Multihead
Monohead
Editor
EOF
)
case $ret in
	Lock)
		~/dotfiles/scripts/lock.sh
		;;

	Reboot)
		shutdown -r now
		;;

	Shutdown)
		shutdown now
		;;

	Record)
		~/dotfiles/scripts/scast.sh &
		;;

	Theme)
		~/dotfiles/scripts/color.sh
		;;

	Screen | Screenshoot)
		~/dotfiles/scripts/screenshot.sh -s
		;;

	Suspend)
		systemctl suspend
		;;

	Music)
		spotify  --no-zygote --disable-gpu --disable-software-rasterizer &
		disown
		;;

	Dock)
		~/dotfiles/scripts/monitors.sh -d
		~/dotfiles/scripts/kb.sh -e
		;;

	Multihead)
		~/dotfiles/scripts/monitors.sh -m
		~/dotfiles/scripts/kb.sh -e
		;;

	Monohead)
		~/dotfiles/scripts/monitors.sh -l
		~/dotfiles/scripts/kb.sh -m
		;;

	Editor)
		alacritty -e nvim &
		disown
		;;

	"")
		: # pass
		;;

	*)
		notify-send Error "Couldn't parse the command"
		;;
esac
