#!/bin/zsh

name=$(date "+Screenshot-%d_%h_%y-at-%H:%M:%S")
cd ~/Pictures

if [[ $1 = windows ]]
then
	sleep 0.5
	xwininfo > screen &
	xdotool click 1 > /dev/null
	id=$( cat screen | grep 'id:' | cut -d ' ' -f 4)
	xwd -id $id -frame -out ${name}.xwd


elif [[ $1 = whole ]] 
then
	xwd -root -out ${name}.xwd &!
	xdotool click 1 > /dev/null
fi

convert ${name}.xwd ${name}.png
rm ${name}.xwd screen 2>/dev/null 

