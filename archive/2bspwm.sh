#!/bin/bash
#
#   double borders
#

outer='0x263238'   # outer
inner1='0xcf9b6a'  # focused
inner2='0x808297'  # normal

bspc config -d 3 border_width 12
bspc config focused_border_color \#${outer#0x}
bspc config normal_border_color \#${outer#0x}
bspc config active_border_color \#${outer#0x}

targets() {
	case $1 in
		focused) bspc query -N -n .local.focused.\!fullscreen;;
		normal)  bspc query -N -n .local.\!focused.\!fullscreen
	esac
}

draw() {
	# only in workspace 3
	[[ -n $(bspc query -N -n -d 3) ]] && \
	chwb2 -I "$inner" -O "$outer" -i "2" -o "9" $* 2> /dev/null
}

# initial draw, and then subscribe to events
{ echo; bspc subscribe node_geometry node_focus; } |
	while read -r _; do
		inner=$inner1 draw "$(targets focused)"
		inner=$inner2 draw "$(targets  normal)"
	done
