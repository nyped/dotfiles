#!/usr/bin/env bash
# install

set -euo pipefail

# Stepping into the directory
cd "$(dirname "$0")"

targets=(
  bat
  dunst
  gammastep
  kitty
  nvim
  scripts
  sway
  swaylock
  theme
  tmux
  tpl
  vim
  waybar
  xsession
  zathura
  zsh
)

function usage() {
  cat << EOF
Usage: ${0##*/} <cmd>
with cmd in:
-i --install
-u --uninstall
-h --help
EOF
}

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

  *)
    usage
    exit 255
    ;;
esac

for package in "${targets[@]}"; do
  mkdir -p ~/.config/"$package"
  stow --ignore="^config" "$cmd" "$package" --dotfiles
done

# vim:set ts=8 sts=2 sw=2 et:
