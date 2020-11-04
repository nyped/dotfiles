#!/bin/sh

echo "cmd:hide" > /tmp/right-ipc
[[ $1 == discord ]] && sleep 5.15 || sleep 2.15
[[ $(cat /tmp/polybar_status) = 0 ]] || echo "cmd:show" > /tmp/right-ipc
