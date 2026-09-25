#!/usr/bin/env zsh

# Shell integrations that need to run after compinit (see binding.sh).

# zoxide: `cd foo` jumps by frecency, `cdi` picks interactively.
# Plain `cd` still works: real paths, `cd -` and `cd -3` are passed through.
if type zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
  # keep the stock names around too
  alias z=cd zi=cdi
fi

# vim: set ts=2 sts=2 sw=2 ft=zsh et :
