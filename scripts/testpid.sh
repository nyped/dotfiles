#!/bin/sh

set $(pidof -x notifbar.sh)
for i in $* ; do kill -9 $i; done >/dev/null 2>&1

( /home/lenny/dotfiles/scripts/notifbar.sh ) &
exit 0
