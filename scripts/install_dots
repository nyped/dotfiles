#!/usr/bin/env bash

dir=(
  ~/.config/bat
  ~/.config/bspwm
  ~/.config/dunst
  ~/.config/nvim
  ~/.config/picom
  ~/.config/polybar
  ~/.config/sxhkd
  ~/.config/alacritty
  ~/.config/zathura
  ~/.config/rofi
  ~/.config/gtk-3.0
)

pacman_deps=(
  bat
  bc
  bspwm
  dunst
  hsetroot
  neovim
  picom
  sxhkd
  alacritty
  xsetroot
  zathura
  zathura-djvu
  zathura-pdf-mupdf
  zsh
)

yay_deps=(
  iwgtk
  polybar
)

fail() {
  echo "$1" >&2
  exit ${2:-255}
}

install_dots() {
  mkdir -p ${dir[@]}
  ln -sf ~/dotfiles/${1:=day}-theme/bat.conf ${dir[0]}/config
  ln -sf ~/dotfiles/bspwm/bspwmrc ${dir[1]}
  ln -sf ~/dotfiles/${1}-theme/dunstrc ${dir[2]}
  ln -sf ~/dotfiles/nvim/init.vim ${dir[3]}
  ln -sf ~/dotfiles/nvim/coc-settings.json ${dir[3]}
  ln -sf ~/dotfiles/X/picom.conf ${dir[4]}
  ln -sf ~/dotfiles/polybar/* ${dir[5]}
  ln -sf ~/dotfiles/bspwm/sxhkdrc ${dir[6]}
  ln -sf ~/dotfiles/${1}-theme/zathurarc ${dir[8]}
  ln -sf ~/dotfiles/${1}-theme/rofi.rasi ${dir[9]}
  ln -sf ~/dotfiles/X/gtk.css ${dir[10]}
  ln -sf ~/dotfiles/scripts/.xinitrc ~
  ln -sf ~/dotfiles/scripts/zshrc ~/.zshrc
  echo ${1} > ~/.t
}

install_deps() {
  echo Installing deps
  sudo pacman -S "${pacman_deps[@]}" || fail "Pacman deps install failed" 1
  which yay &>/dev/null || {
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd -
  }
  yay "${yay_deps[@]}" || fail "Yay deps install failed" 2
}

install_dots day
install_deps

# vim:set ts=8 sts=2 sw=2 et:
