#!/bin/env zsh


function usage() {
echo "\
Usage: ${0##*/} <cmd>
cmd can be:
- hide		hides the bar, updates the top gap
- show		shows the bar, updates the top gap
"
}

function hide() {
	polybar-msg cmd hide
	i3-msg -q gaps top all minus 40
}

function show() {
	polybar-msg cmd show
	i3-msg -q gaps top all plus 40
}

case $1 in
	show)
		show >/dev/null
		echo 1 > /tmp/polybar_status
		;;
	hide)
		hide >/dev/null
		echo 0 > /tmp/polybar_status
		;;
	*)
		usage
		exit 1
		;;
esac
