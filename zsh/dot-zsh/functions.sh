#!/usr/bin/env zsh

function with() {
  typeset -g _with_label

  if [[ $# != 1 ]]; then
    unset _with_label
  else
    _with_label=" with %B%F{yellow}$*%f%b"
  fi
}

function _exists() {
  for var; do
    type "$var" &>/dev/null
  done
}

_exists handlr &&
function open() {
  for file
  do
    handlr open "$file" || return 1
    notify-send "File '${file##*/}' opened" -a notif
  done
}

function share() {
  [[ $# != 1 ]] && echo usage: share \<file\> && return 1
  [[ ! -f $1 ]] && echo File non readable 1>&2 && return 2
  UA="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:89.0) Gecko/20100101 Firefox/89.0"
  curl -A "$UA" -F file=@"$1" http://0x0.st 2>/dev/null
}

# backup
function bak() {
  [[ $# != 1 ]] && echo usage: bak \<file\> && return 1
  [[ -f "$1".bak ]] && echo File "$1".bak exists && return 2
  mv "$1"{,.bak}
}

# replace patterns in filename
function evomer() {
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

function gset() {
  sudo cpupower frequency-set --governor "${1:-performace}"
}

function fset() {
  sudo cpupower frequency-set --min "${1:=1G}"
  sudo cpupower frequency-set --max "${1:=1G}"
}

function drop_caches() {
  sudo sync
  echo 3 | sudo tee /proc/sys/vm/drop_caches
}

# we may wanna avoid fancy stuff in old school terminals
function __in_restricted_term() {
  [[ $(tty) == *tty* || -n $MYVIMRC || -n $TMUX || $TERM != xterm* ]]
}

function __set_title() {
  local TITLE_BEG="\x1b]0;"
  local TITLE_END="\x1b\\"

  echo -en "${TITLE_BEG}${_SSH_TITLE_PREF}$*${TITLE_END}"
}

function __update_title() {
  __set_title "$2"
}

function __get_short_pwd {
  local _PWD

  if [[ $USER == root ]]; then
    _PWD="$PWD"
  else
    _PWD="${PWD/#$HOME/~}"
  fi

  # .abc -> .a
  _PWD="${_PWD//(#b)(\.)([^\/\.])[^\/][^\/]#\//$match[1]$match[2]/}"
  # abc -> a
  _PWD="${_PWD//(#b)([^\/\.])[^\/][^\/]#\//$match[1]/}"
  # ..abc -> ...
  _PWD="${_PWD//(#b)(\.)(\.)([^\/])[^\/][^\/]#\//.../}"

  echo "$_PWD"
}

function __restore_title() {
  __set_title "$(__get_short_pwd)"
}

() {
  autoload -U add-zsh-hook

  __in_restricted_term && return

  add-zsh-hook preexec __update_title
  add-zsh-hook precmd  __restore_title

  if [[ -n $_IN_WSL ]]; then
    add-zsh-hook precmd  __vte_wsl
  fi
}

# vim: set ts=2 sts=2 sw=2 ft=zsh et :
