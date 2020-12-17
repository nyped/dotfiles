#!/usr/bin/env bash

# unused
function ls-term-color() {
	local index
	for index in {31..37}; do printf "\033[${index}m\U2588\U2588"; done
	printf "\n"
	for index in {101..107}; do printf "\033[${index}m  \033[0m"; done
	printf "\n"
}

clear && echo

label=$([[ $THEME = day ]] && printf "\033[31m" || printf "\033[34m")
reset=$(printf "\033[0m")
. /etc/os-release
k=$(uname -r)
s=$(cat /proc/uptime)
s=${s%%.*}
d=$((s/86400))
h=$((s/3600%24))
m=$((s/60%60))
[ $d = 0 ] || u="${u}${d}d "
[ $h = 0 ] || u="${u}${h}h "
[ $m = 0 ] || u="${u}${m}m"

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

echo "
${label}       /\         OS      ${reset}${PRETTY_NAME:-?}
${label}      /  \        PKG     ${reset}$(pacman -Q | wc -l)
${label}     /\   \       UPTIME  ${reset}$u
${label}    /      \      EDITOR  ${reset}${EDITOR:-?}
${label}   /   ,,   \     SHELL   ${reset}${SHELL##*/}
${label}  /   |  |  -\    MEMORY  ${reset}${x}MiB / ${t}MiB
${label} /_-''    ''-_\   KERNEL  ${reset}$k
"