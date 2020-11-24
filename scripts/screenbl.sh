#!/bin/zsh

function update() {
	notify-send Brightness "$(macbook-lighter-screen ${*})" -h string:x-canonical-private-synchronous:anything -a notif
}

# --inc N || --dec N
update $*
