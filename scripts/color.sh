#!/usr/bin/env zsh

if [[ $1 = day || $1 = d ]]; then
	export THEME=day
elif [[ $1 = night || $1 = n ]]; then
	export THEME=night
else
	export THEME=$(< ~/.t)
	[[ $THEME = day ]] && $0 n || $0 d
	exit 0
fi

killall dunst 2>/dev/null 1>&2
hsetroot -cover ~/dotfiles/wallpaper/${THEME}.png >/dev/null 2>&1
ln -sf ~/dotfiles/${THEME}-theme/termite-conf ~/.config/termite/config
ln -sf ~/dotfiles/${THEME}-theme/zathurarc ~/.config/zathura/zathurarc
ln -sf ~/dotfiles/${THEME}-theme/dunstrc ~/.config/dunst/dunstrc
ln -sf ~/dotfiles/${THEME}-theme/rofi.rasi ~/.config/rofi/config.rasi
killall -USR1 termite >/dev/null 2>&1
dunst >/dev/null 2>&1 &!
echo $THEME | tee ~/.t

# vim: set ts=4 sts=4 sw=4 noet :
