#!/usr/bin/env zsh

# Shell integrations that need to run after compinit (see binding.sh).

# zoxide: `z foo` jumps by frecency, `zi` picks interactively.
if type zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# vim: set ts=2 sts=2 sw=2 ft=zsh et :
