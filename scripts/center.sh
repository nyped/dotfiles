#!/usr/bin/env bash

# docs
# https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html

shopt -s extglob

file=/tmp/center.$PPID
max=0
COLUMNS=$(tput cols)
:> $file

while read -r line; do
	echo "$line" >> $file
	tmp=${line//[[:cntrl:]]\[+([[:digit:]])[[:alpha:]]/}
	current=${#tmp}
	[[ $current -gt $max ]] && max=$current
	if [[ $current -gt $COLUMNS ]]; then
		cat $file
		cat
		[[ -f $file ]] && rm $file
		exit 0
	fi
done

n=$((($COLUMNS - $max)/2))
margin=$(printf "%*s" $n " ")

while read -r line; do
	printf "%s%s\n" "$margin" "$line"
done < $file

[[ -f $file ]] && rm $file
