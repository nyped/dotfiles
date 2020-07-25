function max() {
	local max=$1 i
	shift
	for i in $*; do [[ $max -lt $i ]] && max=$i; done
	echo $max
}

function ls-term-color() {
	# $1 is the left margin width
	local index
	printf "%*s" ${1:-0} " "
	for index in {30..37}; do printf "\033[${index}m\U2588\U2588"; done
	printf "\n%*s" ${1:-0} " "
	for index in {100..107}; do printf "\033[${index}m  \033[0m"; done
	printf "\n"
}

function pfe() {
	clear && echo
	local u margin i

	label=$([[ $THEME = day ]] && printf "\033[31m" || printf "\033[34m")
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
	let margin="($COLUMNS - 26 - `max ${#PRETTY_NAME} ${#host} ${#u} ${#EDITOR} ${#SHELL##*/} $((${#x}+${#t}+9)) ${#k} 3`)/2"
	[[ ! -z $1 ]] && label=`printf "%*s${label}" "$margin" " "`
	let margin="($COLUMNS - 16)/2"

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

[[ ! -z $2 ]] && ls-term-color margin || true
}
