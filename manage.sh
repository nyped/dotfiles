#!/usr/bin/env bash
# install
# Fri Apr 29 02:20:49 PM CEST 2022
# lennypeers

target=(
  awesome
  bat
  bspwm
  dunst
  eww
  kitty
  nvim
  picom
  polybar
  rofi
  scripts
  sxhkd
  wallpaper
  Xsession
  zathura
  zsh
)

function usage() {
  cat << EOF
Usage: ${0##*/} [-u | --uninstall | -h | --help]
If no argument is given, installs the targets.
EOF
  exit 0
}

case "$1" in
  -u | --uninstall)
    cmd=-D
    ;;

  -h | --help)
    usage
    ;;

  *)
    cmd=-S
    ;;
esac

for package in ${target[@]}; do
  mkdir -p ~/.config/$package
  stow --ignore="^config" $cmd $package --dotfiles
done

# vim:set ts=8 sts=2 sw=2 et:
