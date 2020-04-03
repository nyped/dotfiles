ZSH_THEME="mortalscumbag"
#trapd00r is also a nice theme

# linux
alias open='xdg-open'
alias cycle='cat /sys/class/power_supply/BAT0/cycle_count'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias sensors="sensors | grep --color=never 'high\|RPM' | cut -d '(' -f 1"
alias r='/usr/lib/R/bin/R' # to get the path -> R.home() 
alias bluetooth='sudo service bluetooth start'

# linux and mac
alias musique='pyradio'
alias maison='cd /home/lenny/Desktop/learning'
alias old='$OLDPWD'
alias dl='cd ~/Downloads'
alias tmp='cd /tmp'
alias vim='nvim'

#linux: new terminal tabs keep the same wd
if [ -e /etc/profile.d/vte.sh ]; then
    . /etc/profile.d/vte.sh
fi

#mac
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000002A}]}' > /dev/null 2>&1

# launching
vache () {
set $(ls /usr/share/cowsay/cows/ | cut -d '.' -f 1 )
x=$(shuf -i 1-45 -n 1)
eval x='$'$x
echo $x
clear && fortune | cowsay -f $x | lolcat
}

# translation
trad () {
echo $@ >> ~/maison/mots.txt
if [ $1 = 'fr' ]
then
shift && echo $@ | trans -shell -b :fr | grep -v "^>$"
else
echo $@ | trans -shell -b | grep -v "^>$"
fi
}

# pandoc function

pan () {
var=$( basename $1 | sed s/.md// | sed s/.pdf// )
pandoc --highlight-style=tango ~/maison/style.md -so $var.pdf $var.md
}

google () {
echo q | googler -n 5 -x $@
}

lyrics () {
# receives 2 arguments : artist and title
# fork of https://gist.github.com/febuiles/1549991
[ $# -ne 2 ] && echo Format: artist title && return 1
artist=$1
title=$2
curl -s --get "https://makeitpersonal.co/lyrics" --data-urlencode "artist=$artist" --data-urlencode "title=$title" | less -FX
}


# colors for less
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
