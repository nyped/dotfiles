export ZSH="/home/lenny/.oh-my-zsh"

ZSH_THEME="lenny"

plugins=(git lenny web-search)

source $ZSH/oh-my-zsh.sh

function color () {
	if [[ $1 = day ]]
		then export THEME=day
		xsetroot -solid "#BCD4E6"
	elif [[ $1 = night ]]
		then export THEME=night
		xsetroot -solid "#ff8533"
	fi

		ln -f ~/dotfiles/termite-conf-${THEME} ~/.config/termite/config
		ln -f ~/dotfiles/i3-config-${THEME} ~/.config/i3/config
		ln -f ~/dotfiles/i3-blocks-${THEME} ~/.config/i3blocks/config
		ln -f ~/dotfiles/zathurarc-${THEME} ~/.config/zathura/zathurarc
		ln -f ~/dotfiles/rofi-theme-${THEME}.rasi ~/.config/rofi/my-theme.rasi
		killall -USR1 termite
		i3-msg -q restart
}

if cat ~/.config/termite/config | grep day > /dev/null 2>&1
	then export THEME=day
	else export THEME=night
fi

if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='nvim'
	export THEME=ssh
else
	export EDITOR='nvim'
fi

function vim () {
	if [[ $THEME = day ]]
		then /bin/nvim -p $* -c ':set background=light'

	elif [[ $THEME = night ]]
		then /bin/nvim -p $* -c ':set background=dark'

	elif [[ $THEME = ssh ]]
		then /bin/nvim -p $* -c ':source ~/.ssh-conf.vim'
	fi
}


alias cycle='cat /sys/class/power_supply/BAT0/cycle_count'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias sensors="sensors | grep --color=never 'high\|RPM' | cut -d '(' -f 1"
alias R='/usr/lib64/R/bin/R' # to get the path -> R.home()
alias bluetooth='systemctl start bluetooth'
alias dl='cd ~/Downloads'
alias tmp='cd /tmp'
alias grep='grep --color=always'

# linux and mac
alias musique='pyradio'
alias maison='cd /home/lenny/Desktop/learning'
alias old='$OLDPWD'

# translation
t () {
	echo $@ >> ~/maison/mots.txt
	if [[ $1 = f ]]
		then shift && echo $@ | trans -shell -b :fr | grep -v "^>$"
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

# opam configuration
test -r /home/lenny/.opam/opam-init/init.zsh && . /home/lenny/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

#linux: new terminal tabs keep the same wd
if [ -e /etc/profile.d/vte.sh ]; then
    . /etc/profile.d/vte.sh
fi

open () {
	local opener
	[[ $# != 1 ]] && echo 1 argument plz && return 1 
	if [[ $( cut -d . -f 2 <<< $1) = pdf ]]
		then opener=zathura
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

# auto startx
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

alias wf='sudo modprobe -r brcmfmac ; sudo modprobe brcmfmac rambase_addr=0x160000'


