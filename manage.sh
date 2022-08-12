#!/usr/bin/env bash
# install
# Fri Apr 29 02:20:49 PM CEST 2022
# lennypeers

target=(
  awesome
  bat
  bspwm
  dunst
  kitty
  nvim
  picom
  polybar
  rofi
  scripts
  sxhkd
  wallpaper
  Xsession
  xsettingsd
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

case "$1" in
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

for package in ${target[@]}; do
  mkdir -p ~/.config/$package
  stow --ignore="^config" $cmd $package --dotfiles
done

# vim:set ts=8 sts=2 sw=2 et:
