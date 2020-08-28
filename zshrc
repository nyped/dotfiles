export ZSH="/home/lenny/.oh-my-zsh"

ZSH_THEME="simple"

plugins=(git lenny web-search)

source $ZSH/oh-my-zsh.sh
source ~/.id

export EDITOR=nvim
export MANPAGER='nvim -u NORC +"set ft=man nocul noshowcmd noruler noshowmode laststatus=2" +"let w:airline_disabled=1" +"set statusline=\ %t%=%p%%\ L%l:C%c\ " --noplugin'

function color () {
	if [[ ${1[1]} = d ]]; then
		export THEME=day B3=145
	elif [[ ${1[1]} = n ]]; then
		export THEME=night B3=031
	else
		[[ $THEME = day ]] && color n || color d
		return 0
	fi

	local pic_path=~/Pictures/${THEME}.png

	hsetroot -cover $pic_path >/dev/null || hsetroot -solid "$_BG"
	ln -sf ~/dotfiles/${THEME}-theme/termite-conf ~/.config/termite/config
	ln -sf ~/dotfiles/${THEME}-theme/zathurarc ~/.config/zathura/zathurarc
	ln -sf ~/dotfiles/${THEME}-theme/rofi-theme.rasi ~/.config/rofi/my-theme.rasi
	killall -USR1 termite
	clear
}

if cat ~/.config/termite/config | grep day > /dev/null 2>&1
	then export THEME=day B3=145
	else export THEME=night B3=031 _BG=#ffa366
fi

function vim () {
	if [[ $THEME = day ]]; then
		/bin/nvim -p $* -c ':set background=light'

	elif [[ $THEME = night ]]; then
		/bin/nvim -p $* -c "let g:airline_theme='papercolor'" -c ":set background=dark"

	elif [[ $THEME = ssh ]]; then
		/bin/nvim -p $*
	fi
}

function bat () {
	[[ $THEME = night ]] && \
		/bin/bat --theme ansi-dark $* || \
		/bin/bat --theme GitHub $*
}

alias cycle='cat /sys/class/power_supply/BAT0/cycle_count'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias sensors="sensors | grep --color=never 'high\|RPM' | cut -d '(' -f 1"
alias R='/usr/lib64/R/bin/R' # to get the path -> R.home()
alias dl='cd ~/Downloads'
alias tmp='cd /tmp'
alias grep='grep --color=always'

# linux and mac
alias maison='cd /home/lenny/Desktop/learning'

# translation
t () {
	echo $@ >> ~/maison/mots.txt
	if [[ $1 = f ]]; then
		shift && echo $@ | trans -shell -b :fr | grep -v "^>$"
	else
		echo $@ | trans -shell -b | grep -v "^>$"
	fi
}

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

lyrics () {
# receives 2 arguments : artist and title
# fork of https://gist.github.com/febuiles/1549991
	[[ $# != 2 ]] && echo Format: artist title && return 1
	artist=$1
	title=$2
	curl -s --get "https://makeitpersonal.co/lyrics" --data-urlencode "artist=$artist" --data-urlencode "title=$title" | less -FX
}

#linux: new terminal tabs keep the same wd
if [ -e /etc/profile.d/vte.sh ]; then
    . /etc/profile.d/vte.sh
fi

open () {
	local opener
	[[ $# != 1 ]] && echo 1 argument plz && return 1
	if [[ $( cut -d . -f 2 <<< $1) = pdf ]]; then
		opener=zathura
	fi
	${opener:-xdg-open} $@ >/dev/null 2>&1 &!
}

lorem () {
	curl -s http://metaphorpsum.com/sentences/3 | pbcopy
}

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

# for ssh
export TERM=xterm-256color

# colors
export C='--color=always'

# auto startx
if [[ $(tty) = /dev/tty1 ]]; then
	exec startx
fi

# sharing text stuff -> pbs = paste bin share
alias pbs='nc termbin.com 9999|pbcopy && pbpaste'
