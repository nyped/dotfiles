#!/usr/bin/env zsh

unsetopt beep

# keybinds
bindkey -e
bindkey "^U" backward-kill-line
function _zle_ls() {
  zle push-line
  BUFFER=" ls"
  zle accept-line
}
zle -N _zle_ls
bindkey '^[l' _zle_ls

# tab completion
eval "$(dircolors)"
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} "ma=30;1;42;21"
zstyle ':completion:*' matcher-list \
  '' \
  'm:{a-zA-Z}={A-Za-z}' \
  'm:{A-Z}={a-z} r:|[._-/]=* r:|=* l:|=*' \
  'm:{a-z}={A-Z} r:|[._-/]=* r:|=* l:|=*' \
  'r:|[._-/]=* r:|=* l:|=*'
zmodload zsh/complist
compinit
bindkey '^[[Z' reverse-menu-complete

# arrow search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# alt n, alt p doing the same thing as arrows
bindkey "^[p" history-beginning-search-backward-end
bindkey "^[n" history-beginning-search-forward-end
# home and end, bruh
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# delete word
autoload -U select-word-style
select-word-style bash
export WORDCHARS='.-'

# vim: set ts=2 sts=2 sw=2 ft=zsh et :
