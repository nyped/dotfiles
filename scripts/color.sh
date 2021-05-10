#!/usr/bin/env zsh

if [[ $1 = day || $1 = d ]]; then
	THEME=day
elif [[ $1 = night || $1 = n ]]; then
	THEME=night
else
	THEME=$(< ~/.t)
	[[ $THEME = day ]] && $0 n || $0 d
	exit 0
fi

echo $THEME > ~/.t
killall dunst 2>/dev/null 1>&2
killall -SIGUSR1 nvim >/dev/null 2>&1
hsetroot -cover ~/dotfiles/wallpaper/${THEME}.png >/dev/null 2>&1
ln -sf ~/dotfiles/${THEME}-theme/zathurarc ~/.config/zathura/zathurarc
ln -sf ~/dotfiles/${THEME}-theme/dunstrc ~/.config/dunst/dunstrc
ln -sf ~/dotfiles/${THEME}-theme/rofi.rasi ~/.config/rofi/config.rasi
ln -sf ~/dotfiles/${THEME}-theme/bat.conf ~/.config/bat/config
cat ~/dotfiles/${THEME}-theme/alacritty.yml > ~/.config/alacritty/alacritty.yml
dunst >/dev/null 2>&1 &!

# vim: set ts=4 sts=4 sw=4 noet :
