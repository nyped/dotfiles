#!/usr/bin/env bash
# menu

set -euo pipefail

font='JetBrains Mono Bold 10'
bg='\#232323'
fg='\#b3b3b3'
hi='\#00afaf'

flock -n /tmp/sway_menu.lock -c \
  "bemenu -p \"$1\" --fn \"$font\" -H 30 --tb $bg --tf $fg --fb $bg --ff $fg --cb $bg --cf $fg --nb $bg --nf $fg --ab $bg --af $fg --fbb $bg --fbf $fg --hb $hi --hf $bg"

# vim:set ts=8 sts=2 sw=2 et:
