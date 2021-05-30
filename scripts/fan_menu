#!/bin/bash
#
# change fan speed with rofi dmenu

shopt -s extglob

ret=$(echo -e "Toggle\nSlow\nMedium\nFast" | rofi -dmenu -i -p "Fan menu:" -lines 2 -columns 2)

case $ret in
	[Tt]oggle)
		if [ $(sudo /bin/fan toggle) = 0 ]
			then mes="Fan in auto-control"
			else mes="Fan in manual control"
		fi
		;;

	+([[:digit:]]))
		echo $ret a
		if [ -1 -le $ret -a $ret -le 6500 ]
		then
			sudo fan $ret
			mes="Set to $ret rpm"
		else
			mes="Incorrect fan speed"
		fi
		;;

	[[:digit:]]k)
		sudo fan $ret
		mes="Set to ${ret/k/000} rpm"
		;;

	[Mn]edium)
		sudo fan 4000
		mes="Set to 4000 rpm"
		;;

	[Ff]ast)
		sudo fan 6000
		mes="Set to 6000 rpm"
		;;

	[Ss]low)
		sudo fan 2000
		mes="Set to 2000 rpm"
		;;

	"")
		;;

	*)
		mes="Failed to parse command"
		;;
esac

[ -z "$mes" ] || notify-send Fan "$mes" -a notif
