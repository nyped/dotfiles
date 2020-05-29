function pfe() {
	clear && echo

	image=$(printf "\033[48;5;1m\033[38;5;0m")
	label=$(printf "\033[48;5;0m\033[38;5;1m")
	reset=$(printf "\033[0m")
	. /etc/os-release;k=`uname -r`;s=`cat /proc/uptime`;s=${s%%.*};d=$((s/86400));h=$((s/3600%24));m=$((s/60%60));[ $d = 0 ]||u="${u}${d}d ";[ $h = 0 ]||u="${u}${h}h ";[ $m = 0 ]||u="${u}${m}m";while IFS=: read -r a b;do b=${b%kB};case $a in MemTotal)x=$((x+=b));t=$((t=b));;Shmem)x=$((x+=b));;MemFree|Buffers|Cached|SReclaimable)x=$((x-=b));;esac;done</proc/meminfo;x=$((x/=1024));t=$((t/=1024))

	echo "
	${image}       /\       ${label}  USER    ${reset}${USER}@`hostname`
	${image}      /  \      ${label}  OS      ${reset}${PRETTY_NAME:-?}
	${image}     /\   \     ${label}  UPTIME  ${reset}$u
	${image}    /      \    ${label}  EDITOR  ${reset}${EDITOR:-?}
	${image}   /   ,,   \   ${label}  SHELL   ${reset}${SHELL##*/}
	${image}  /   |  |  -\  ${label}  MEMORY  ${reset}${x}MiB / ${t}MiB
	${image} /_-''    ''-_\ ${label}  KERNEL  ${reset}$k
	${image}                ${label}  PKGS    ${reset}`pacman -Q | wc -l`
	"

	unset u
}

function screenshot() {

	[[ $# -ne 1 ]] && return 1

	name=$(date "+Screenshot-%d_%h_%y-at-%H:%M:%S")
	cd ~/Pictures

	if [ "$1" = "windows" ]
	then
		xwininfo > screen &!
		xdotool click 1 > /dev/null
		id=$(; cat screen | grep 'id:' | cut -d ' ' -f 4)
		xwd -id $id -frame -out ${name}.xwd


	elif [ "$1" = "whole" ] 
	then
		xwd -root -out ${name}.xwd &!
		sleep 0.5
		xdotool click 1 > /dev/null
	fi

	convert ${name}.xwd ${name}.png 2>/dev/null
	rm ${name}.xwd screen 2>/dev/null 
	cd $OLDPWD

}
