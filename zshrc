##
### source https://github.com/lennypeers/dotfiles
##

#
## Zsh stuff
#

export ZSH="/home/lenny/.oh-my-zsh"
ZSH_THEME="simple"
plugins=(git lenny web-search zsh-syntax-highlighting history systemd)
source $ZSH/oh-my-zsh.sh

#
## Colors, theme stuff
#

source ~/.id

function color () {
	if [[ ${1[1]} = d ]]; then
		export THEME=day
	elif [[ ${1[1]} = n ]]; then
		export THEME=night
	else
		[[ $THEME = day ]] && color n || color d
		return 0
	fi

	killall dunst
	[[ $THEME == day ]] && export BGG=\#efdba9 || export BGG=\#a2b9bc

	hsetroot -solid $BGG
	ln -sf ~/dotfiles/${THEME}-theme/termite-conf ~/.config/termite/config
	ln -sf ~/dotfiles/${THEME}-theme/zathurarc ~/.config/zathura/zathurarc
	ln -sf ~/dotfiles/${THEME}-theme/dunstrc ~/.config/dunst/dunstrc
	ln -sf ~/dotfiles/${THEME}-theme/rofi.rasi ~/.config/rofi/config.rasi
	killall -USR1 termite
	clear
	dunst >/dev/null 2>&1 &!
}

if cat ~/.config/termite/config | grep day > /dev/null 2>&1
	then export THEME=day BGG=\#efdba9
	else export THEME=night BGG=\#a2b9bc
fi

#
## Env vars
#

export \
	LESS_TERMCAP_mb=$(tput bold; tput setaf 41) green		\
	LESS_TERMCAP_md=$(tput bold; tput setaf 6)			\
	LESS_TERMCAP_me=$(tput sgr0)					\
	LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 24)	\
	LESS_TERMCAP_se=$(tput rmso; tput sgr0)				\
	LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 9)		\
	LESS_TERMCAP_ue=$(tput rmul; tput sgr0)				\
	LESS_TERMCAP_mr=$(tput rev)					\
	LESS_TERMCAP_mh=$(tput dim)					\
	LESS_TERMCAP_ZN=$(tput ssubm)					\
	LESS_TERMCAP_ZV=$(tput rsubm)					\
	LESS_TERMCAP_ZO=$(tput ssupm)					\
	LESS_TERMCAP_ZW=$(tput rsupm)					\
	TERM=xterm-256color						\
	EDITOR=nvim							\
	MANPAGER='nvim -u NORC +"set ft=man nocul noshowcmd noruler noshowmode laststatus=2" +"let w:airline_disabled=1" +"set statusline=\ %t%=%p%%\ L%l:C%c\ " --noplugin'

#
## aliases
#

alias \
	cycle='cat /sys/class/power_supply/BAT0/cycle_count'			\
	pbcopy='xclip -selection clipboard'					\
	pbpaste='xclip -selection clipboard -o'					\
	sensors="sensors | grep --color=never 'high\|RPM' | cut -d '(' -f 1"	\
	dl='cd ~/Downloads'							\
	tmp=/tmp								\
	grep='grep --color=always'						\
	vim=nvim								\
	vr='nvim -R'								\
	v=nvim									\
	maison='cd /home/lenny/Desktop/learning'				\
	pbs='nc termbin.com 9999|pbcopy && pbpaste'				\
	p=pacman								\
	o=open									\
	m=make									\
	mc='make clean'								\
	b=bat

#
## functions
#

# bat them mod
function bat () {
	[[ $THEME = night ]] && \
		/bin/bat --theme ansi-dark $* || \
		/bin/bat --theme GitHub $*
}

# translation
t () {
	echo $@ >> ~/maison/mots.txt
	if [[ $1 = f ]]; then
		shift && echo $@ | trans -shell -b :fr | grep -v "^>$"
	else
		echo $@ | trans -shell -b | grep -v "^>$"
	fi
}

# dictionary
def () {
	[[ $# -lt 1 ]] && echo Entrez un mot ou plus && return 1
	echo $@ >> ~/maison/def.txt
	echo $@ | trans | less -FX
}

# pandoc function
pan () {
	var=$( basename $1 | sed s/.md// | sed s/.pdf// )
	pandoc --highlight-style=tango ~/maison/style.md -so $var.pdf $var.md
}

# karaoke stuff lmao
lyrics () {
# receives 2 arguments : artist and title
# fork of https://gist.github.com/febuiles/1549991
	[[ $# != 2 ]] && echo Format: artist title && return 1
	artist=$1
	title=$2
	curl -s --get "https://makeitpersonal.co/lyrics" --data-urlencode "artist=$artist" --data-urlencode "title=$title" | less -FX
}

open () {
	local opener
	while [[ $# != 0 ]]; do
		if [[ ${1##*.} = pdf ]]; then
			opener=zathura
		else
			opener=xdg-open
		fi
		$opener $1 >/dev/null 2>&1 &!
		notify-send "${1##*/}" "Opened by $opener" -a notif
		shift
	done
}

# random text
lorem () {
	curl -s http://metaphorpsum.com/sentences/3 | pbcopy
}

#linux: new terminal tabs keep the same wd
if [ -e /etc/profile.d/vte.sh ]; then
	. /etc/profile.d/vte.sh
fi

#auto startx
if [[ $(tty) = /dev/tty1 ]]; then
	echo 1 > /tmp/polybar_status
	exec startx
fi

# zle stuff
export \
	ZSH_HIGHLIGHT_STYLES[arg0]="none"			\
	ZSH_HIGHLIGHT_STYLES[path]="fg=cyan,bold"		\
	ZSH_HIGHLIGHT_STYLES[redirection]="fg=yellow,bold"	\
	ZSH_HIGHLIGHT_STYLES[autodirectory]="fg=blue,bold"	\
	ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=yellow,bold"
