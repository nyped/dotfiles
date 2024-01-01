#!/usr/bin/env zsh

open() {
  for file
  do
    handlr open "$file" || return 1
    notify-send "File '${file##*/}' opened" -a notif
  done
}

share() {
  [[ $# != 1 ]] && echo usage: share \<file\> && return 1
  [[ ! -f $1 ]] && echo File non readable 1>&2 && return 2
  curl -F file=@"$1" http://0x0.st 2>/dev/null
}

# backup
bak() {
  [[ $# != 1 ]] && echo usage: bak \<file\> && return 1
  [[ -f "$1".bak ]] && echo File "$1".bak exists && return 2
  mv "$1"{,.bak}
}

# replace patterns in filename
evomer() {
  [[ $# = 0 ]] && {
    echo 'usage: [F=pat1] [R=pat2] evomer <files>' >&2
    return 1
  }

  local tmp
  for file
  do
    tmp="${file//${F:= }/${R:=_}}"
    [[ "$tmp" == "$file" ]] && continue
    if [[ -f $tmp ]]
      then echo "$tmp" exists >&2
      else mv "$file" "$tmp"
    fi
  done
}

# set cpu governor, frequency
gset() sudo cpupower frequency-set --governor "${1:-performace}"
fset() sudo cpupower frequency-set --min "${1:=1G}" --max "$1"

function drop_caches() {
  sudo sync
  echo 3 | sudo tee /proc/sys/vm/drop_caches
}

# fzf
function fzf-cd() {
  local target="$(fd --type d | fzf +m --preview "tree -C {}")"
  
  [[ -d $target ]] && cd "$target"
}

# we may wanna avoid fancy stuff in old school terminals
function __in_restricted_term() {
  [[ $(tty) == *tty* || -n $VIMRUNTIME || -n $TMUX ]]
}

function __update_title() {
  local CMD TITLE_BEG TITLE_END BOLD

  __in_restricted_term && return

  CMD="$2"
  TITLE_BEG="\e]0;"
  TITLE_END="\007"
  BOLD="\033[1m"

  # Print the title without expanding the command
  print -Pn "$TITLE_BEG$BOLD"
  print -n  "$_SSH_TITLE_PREF$CMD"
  print -Pn "$TITLE_END"
}

function __restore_title_cursor() {
  local UNDERSCORE TITLE_BEG TITLE_END _PWD

  __in_restricted_term && return

  UNDERSCORE="\033[4 q"
  TITLE_BEG="\e]0;"
  TITLE_END="\007"
  BOLD="\033[1m"
  _PWD="${${PWD/#$HOME/~}//(#b)([^\/])[^\/][^\/]#\//$match[1]/}"

  print -Pn "$UNDERSCORE"
  print -Pn "$TITLE_BEG$BOLD$_SSH_TITLE_PREF$_PWD$TITLE_END"
}

() {
  autoload -U add-zsh-hook

  add-zsh-hook preexec __update_title
  add-zsh-hook precmd __restore_title_cursor
}

# vim: set ts=2 sts=2 sw=2 ft=zsh et :
