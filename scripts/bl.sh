#!/bin/bash

# --inc N || --dec N
notify-send Brightness "$(macbook-lighter-screen ${*})" -h string:x-canonical-private-synchronous:anything -a notif
