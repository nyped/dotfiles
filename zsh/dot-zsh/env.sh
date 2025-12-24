#!/usr/bin/env zsh

# History
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history

# man and pager stuff
export LESS="-r --mouse --wheel-lines=2"
if _exists tput; then
  export LESS_TERMCAP_mb=$(tput bold; tput setaf 41)
  export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
  export LESS_TERMCAP_me=$(tput sgr0)
  export LESS_TERMCAP_so=$(tput bold; tput setaf 231; tput setab 241)
  export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
  export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 9)
  export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
  export LESS_TERMCAP_mr=$(tput rev)
  export LESS_TERMCAP_mh=$(tput dim)
  export LESS_TERMCAP_ZN=$(tput ssubm)
  export LESS_TERMCAP_ZV=$(tput rsubm)
  export LESS_TERMCAP_ZO=$(tput ssupm)
  export LESS_TERMCAP_ZW=$(tput rsupm)
fi
export EDITOR=nvim
export MANROFFOPT="-c"
export TERM="xterm-256color"

if [[ -n $_IN_WSL ]]; then
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
else
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# syntax highlight
if [[ -n $ZSH_HIGHLIGHT_STYLES ]]; then
  export ZSH_HIGHLIGHT_STYLES[arg0]="none"
  export ZSH_HIGHLIGHT_STYLES[path]="fg=cyan,bold"
  export ZSH_HIGHLIGHT_STYLES[comment]="fg=blue,bold"
  export ZSH_HIGHLIGHT_STYLES[redirection]="fg=yellow,bold"
  export ZSH_HIGHLIGHT_STYLES[autodirectory]="fg=blue,bold"
  export ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=yellow,bold"
fi

# vim: set ts=2 sts=2 sw=2 ft=zsh et :
