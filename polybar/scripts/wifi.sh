#!/bin/env zsh

while :; do
	for i in $(netctl list | sed s/\\\*\ //); do
		netctl status $i | sed s/inactive// | grep active >/dev/null 2>&1 && echo 直 && break || echo 睊
	done
	sleep 10;
done
