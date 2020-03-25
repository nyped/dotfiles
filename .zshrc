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
vache

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
pandoc --highlight-style=tango -so $var.pdf $var.md
}

google () {
echo q | googler -n 5 -x $@
}
