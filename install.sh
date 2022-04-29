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
  scripts
  sxhkd
  wallpaper
  Xsession
  zathura
  zsh
)

for package in ${target[@]}; do
  stow $package
done

# vim:set ts=8 sts=2 sw=2 et:
