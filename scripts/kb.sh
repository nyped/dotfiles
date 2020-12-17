#!/bin/bash

# --inc N || --dec N
notify-send Backlight "$(macbook-lighter-kbd ${*})" -h string:x-canonical-private-synchronous:anything -a notif
