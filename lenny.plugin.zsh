function ls-term-color() {
	local index
	for index in {30..39} {100..107}
	do
		printf "\033[${index}m\U2588\U2588\033[0m "
	done
	printf "\n"
}

function pfe() {
	clear && echo

	label=$(printf "\033[34m")
	reset=$(printf "\033[0m")
	. /etc/os-release
	k=`uname -r`
	s=`cat /proc/uptime`
	s=${s%%.*}
	d=$((s/86400))
	h=$((s/3600%24))
	m=$((s/60%60))
	[ $d = 0 ]||u="${u}${d}d "
	[ $h = 0 ]||u="${u}${h}h "
	[ $m = 0 ]||u="${u}${m}m"

	while IFS=: read -r a b
	do 
		b=${b%kB}
		case $a in
		MemTotal)
			x=$((x+=b))
			t=$((t=b));;
		Shmem) 
			x=$((x+=b)) ;;
		MemFree|Buffers|Cached|SReclaimable)
			x=$((x-=b));;
		esac;
	done < /proc/meminfo

	x=$((x/=1024))
	t=$((t/=1024))
	host=$(cat /sys/devices/virtual/dmi/id/product_name)

	echo "
	${label}       /\         OS      ${reset}${PRETTY_NAME:-?}
	${label}      /  \        HOST    ${reset}${host:-?}
	${label}     /\   \       UPTIME  ${reset}$u
	${label}    /      \      EDITOR  ${reset}${EDITOR:-?}
	${label}   /   ,,   \     SHELL   ${reset}${SHELL##*/}
	${label}  /   |  |  -\    MEMORY  ${reset}${x}MiB / ${t}MiB
	${label} /_-''    ''-_\   KERNEL  ${reset}$k
	${label}                  PKGS    ${reset}`pacman -Q | wc -l`
	"
	unset u

[[ ! -z $1 ]] && printf	"    " && ls-term-color
}

function screenshot() {
	[[ $# -ne 1 ]] && return 1

	local name=$(date "+Screenshot-%d_%h_%y-at-%H:%M:%S")
	cd ~/Pictures

	if [ "$1" = "windows" ]
	then
		xwininfo > screen &!
		xdotool click 1 > /dev/null
		local id=$(cat screen | grep 'id:' | cut -d ' ' -f 4)
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
