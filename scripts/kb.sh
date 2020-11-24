#!/bin/zsh

function update() {
	notify-send Backlight "$(macbook-lighter-kbd ${*})" -h string:x-canonical-private-synchronous:anything -a notif
}

# --inc N || --dec N
update $*
