##
### source https://github.com/lennypeers/dotfiles
##

#
## Zsh stuff
#

export ZSH="/home/lenny/.oh-my-zsh"
ZSH_THEME="simple"
plugins=(git lenny web-search)
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

	local pic_path=~/Pictures/${THEME}.png
	killall dunst

	hsetroot -cover $pic_path >/dev/null
	ln -sf ~/dotfiles/${THEME}-theme/termite-conf ~/.config/termite/config
	ln -sf ~/dotfiles/${THEME}-theme/zathurarc ~/.config/zathura/zathurarc
	ln -sf ~/dotfiles/${THEME}-theme/rofi-theme.rasi ~/.config/rofi/my-theme.rasi
	ln -sf ~/dotfiles/${THEME}-theme/dunstrc ~/.config/dunst/dunstrc
	killall -USR1 termite
	clear
	dunst >/dev/null 2>&1 &!
}

if cat ~/.config/termite/config | grep day > /dev/null 2>&1
	then export THEME=day
	else export THEME=night
fi

#
## Env vars
#

export LESS_TERMCAP_mb=$(tput bold; tput setaf 41) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 24) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 9) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
export TERM=xterm-256color
export EDITOR=nvim
export MANPAGER='nvim -u NORC +"set ft=man nocul noshowcmd noruler noshowmode laststatus=2" +"let w:airline_disabled=1" +"set statusline=\ %t%=%p%%\ L%l:C%c\ " --noplugin'

#
## aliases
#

alias cycle='cat /sys/class/power_supply/BAT0/cycle_count'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias sensors="sensors | grep --color=never 'high\|RPM' | cut -d '(' -f 1"
alias dl='cd ~/Downloads'
alias tmp=/tmp
alias grep='grep --color=always'
alias vim=nvim
alias vr='nvim -R'
alias v=nvim
alias maison='cd /home/lenny/Desktop/learning'
alias pbs='nc termbin.com 9999|pbcopy && pbpaste'
alias p=pacman
alias o=open
alias m=make
alias mc='make clean'

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
		notify-send "${1##*/}" "Opened by $opener" -a all
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
	exec startx
fi
