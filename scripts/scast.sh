#!/bin/bash

cd ~/Videos
name=$(date "+%Y-%m-%d-%H.%M.%S-screencast.mp4")

ffmpeg -f x11grab -video_size 1440x900 -framerate 60 -i $DISPLAY -c:v libx264 -preset ultrafast -c:a aac $name >/dev/null 2>&1
