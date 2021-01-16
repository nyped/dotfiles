#!/bin/bash
#
# https://michaelabrahamsen.com/posts/custom-lockscreen-i3lock/
# lockscreen with blur

bg=$(mktemp -u).png
scrot $bg
convert $bg -filter Gaussian -thumbnail 20% -sample 500% $bg
i3lock -i $bg
rm $bg
