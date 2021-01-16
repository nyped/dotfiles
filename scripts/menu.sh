#!/usr/bin/env bash

ret=$(echo -e "Lock\nReboot\nRecord\nTheme\nShutdown\nScreenshot" | rofi -dmenu -i -p Do: -lines 3 -columns 3)

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

	Screenshot)
		~/dotfiles/scripts/screenshot.sh -s
		;;

	"")
		: # pass
		;;

	*)
		notify-send Error "Couldn't parse the command"
		;;
esac
