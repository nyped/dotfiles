#!/bin/sh

echo "cmd:hide" > /tmp/right-ipc
[[ $1 == discord ]] && sleep 5.15 || sleep 2.15
echo "cmd:show" > /tmp/right-ipc
