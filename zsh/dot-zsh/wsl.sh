#!/usr/bin/env zsh

# WSL check
if [[ -f /etc/wsl.conf ]]; then
  export _IN_WSL=true

  function __vte_wsl() {
    printf "\033]7;file://localhost$PWD\033\\"
  }

  function code() {
    [[ $# != 1 ]] && return
    case "$1" in
      '.') target="$PWD" ;;
      *)   target="$1" ;;
    esac
    powershell.exe code --remote wsl+Ubuntu-24.04 "$target"
  }
fi

# vim: set ts=2 sts=2 sw=2 ft=zsh et :
