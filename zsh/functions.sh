#!/usr/bin/env zsh

# theme
color() {
  (~/dotfiles/scripts/color "$1")
}

# translation
t() {
  echo $@ >> ~/maison/mots.txt
  if [[ $1 = f ]]; then
    shift && echo $@ | trans -shell -b :fr | grep -v "^>$"
  else
    echo $@ | trans -shell -b | grep -v "^>$"
  fi
}

# dictionary
def() {
  [[ $# -lt 1 ]] && echo usage: def \<stuff\> && return 1
  echo $@ >> ~/maison/def.txt
  echo $@ | trans | less -FX
}

# pandoc
pan() {
  [[ $# != 1 ]] && {
    cat <<EOF >&2
echo usage: [OUT | HI | IN] pan <file>
EOF
    return 1
  }
  var="${1%.*}"
  pandoc ${PAN_EXTRA} --highlight-style="${HI:-tango}" -so "$var"."${OUT:-pdf}" "$var"."${IN:-md}"
}

# karaoke stuff lmao
lyrics() {
# receives 2 arguments : artist and title
# fork of https://gist.github.com/febuiles/1549991
  [[ $# != 2 ]] && echo usage: lyrics \<artist\> \<title\> && return 1
  {
  echo -e $1 - $2 "\n"
  curl -s --get "https://makeitpersonal.co/lyrics" --data-urlencode \
    "artist=$1" --data-urlencode "title=$2"
  } | ~/dotfiles/scripts/center | less -FX
}

genius() {
  [[ $# != 2 ]] && {
    song | IFS=- read artist title
  } || {
    artist="$1" title="$2"
  }

  ff duckduckgo "\!genius $artist - $title"
  notify-send Lyrics "Firefox tab opened for $artist - $title"
}

lyr() {
  song | IFS=- read artist title
  lyrics "$artist" "$title"
}

open() {
  local opener
  while [[ $# != 0 ]]; do
    if [[ ${1##*.} = pdf ]]; then
      opener=zathura
    else
      opener=xdg-open
    fi
    $opener $1 >/dev/null 2>&1 &!
    notify-send "${1##*/}" "Opened by $opener" -a notif
    shift
  done
}

# random text
lorem() {
  curl -s http://metaphorpsum.com/sentences/3 | pbcopy
}

share() {
  [[ $# != 1 ]] && echo usage: share \<file\> && return 1
  [[ ! -f $1 ]] && echo File non readable 1>&2 && return 2
  curl -F file=@$1 http://0x0.st 2>/dev/null | pbcopy && pbpaste
}

# replace patterns in file name
# by default:
# F=' ' R= evomer stuff
evomer() {
  [[ $# = 0 ]] && \
  echo usage: \[F=pat1\] \[R=pat2\] evomer \<files\> >&2 && \
  return 1

  for i in $* ; do
    tmp=${i//${F:= }/${R}}
    [[ "$tmp" == "$i" ]] && continue
    if [[ -f $tmp ]];
      then echo $tmp exists >&2
      else mv $i $tmp
    fi
  done
}

mount_dev() {
  [[ $# == 0 ]] && \
    echo usage: mmount \<device\> \[destination\] >&2 && \
    return 255

  [[ "${1:h2}" != "/dev" ]] && \
    echo Select a device >&2 && \
    return 254

  echo Mounting the device:
  sudo mount -o gid=users,fmask=113,dmask=002 "$1" "${2:-/mnt}" \
    && echo mounted successfully \
    || echo error
}

rm_orphans() {
  orphans="$(pacman -Qqtd)"
  echo "Removing: $orphans"
  echo $orphans | sudo pacman -Rns -
}

function show_path_shell() {
  if [[ ${#PWD} -gt "$(($COLUMNS/2))" ]]; then
    if [[ ${#PWD:t} -gt "$(($COLUMNS/2))" ]]; then
      # fish like wd but with shrinked tail
      echo \ \%B${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}}//\/~/\~}/${${PWD:t}:0:10}%b...%B${${PWD:t}:$((${#PWD:t}-10)):10}
    else
      # fish like wd with expanded tail
      echo \ \%B${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
    fi
  else
    # full size wd (ommit home dir)
    echo \ \%B%~
  fi
}

preexec () {
  # change the title of the window
  # when running a command
  local cmd=$2
  print -Pn "\e]0;$cmd\a"
}

precmd() {
  # restore window title when command
  # is done
  printf "\033[4 q"
  print -Pn "\e]0;$(show_path_shell)\a"
}

# vim: set ts=2 sts=2 sw=2 ft=sh et :
