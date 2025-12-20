#!/usr/bin/env bash

set -euo pipefail

# Stepping into the directory
cd "$(dirname "$0")"

readonly VERBOSE_ARGS=--verbose=2

readonly targets=(
  bat
  dunst
  fuzzel
  kitty
  niri
  nvim
  scripts
  sway
  swaylock
  theme
  tmux
  vim
  waybar
  xsession
  zathura
  zsh
)

function usage() {
  cat << EOF
Usage: ${0} options

with options in:
-t | --target TARGET
-i | --install
-u | --uninstall
-h | --help
-v | --verbose
-l | --list
EOF
}

function list_target() {
  echo Available targets: 
  for package in "${targets[@]}"; do
    echo "- $package"
  done
}

target=all
cmd=none

while [[ $# != 0 ]]; do
  case "${1:-}" in
    -i | --install)
      cmd=-S
      ;;

    -u | --uninstall)
      cmd=-D
      ;;

    -h | --help)
      usage
      exit 0
      ;;

    -t | --target)
      shift
      target="$1"
      ;;

    -v | --verbose)
      set -x
      ;;

    -l | --list)
      list_target
      exit 0
      ;;

    *)
      usage
      exit 255
      ;;
  esac
  shift
done

if [[ $cmd == none ]]; then
  echo Flag -i or -u must be specified >&2
  exit 1
fi

function install_pkg() {
  mkdir -p ~/.config/"$1"
  stow "$VERBOSE_ARGS" --ignore="^config" "$cmd" "$1" --dotfiles
}

if [[ $target == all ]]; then
  for package in "${targets[@]}"; do
    install_pkg "$package"
  done
else
  install_pkg "$target"
fi

# vim:set ts=8 sts=2 sw=2 et:
