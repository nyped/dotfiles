#!/usr/bin/env zsh

# theme
color() {
  ~/bin/color $1
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
  local var="${1%.*}"
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
  } | ~/bin/center | less -FX
}

genius() {
  local artist title

  [[ $# != 2 ]] && {
    song | IFS=- read artist title
  } || {
    artist="$1" title="$2"
  }

  ff duckduckgo "\!genius $artist - $title"
  notify-send Lyrics "Firefox tab opened for $artist - $title"
}

lyr() {
  local artist title

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

  local tmp

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
  local orphans="$(pacman -Qqtd)"

  echo "Removing: $orphans"
  echo $orphans | sudo pacman -Rns -
}

function _update_title() {
  # change the title of the window
  # when running a command
  local CMD TITLE_BEG TITLE_END BOLD

  CMD="$2"
  TITLE_BEG="\e]0;"
  TITLE_END="\a"
  BOLD="\033[1m"

  print -Pn "$TITLE_BEG$BOLD$CMD\a$TITLE_END"
}

function _restore_title_cursor() {
  local UNDERSCORE TITLE_BEG TITLE_END _PWD

  UNDERSCORE="\033[4 q"
  TITLE_BEG="\e]0;"
  TITLE_END="\a"
  BOLD="\033[1m"
  _PWD="${${PWD/#$HOME/~}//(#b)([^\/])[^\/][^\/]#\//$match[1]/}"

  print -Pn "$UNDERSCORE$TITLE_BEG$BOLD$_PWD$TITLE_END"
}

() {
  autoload -U add-zsh-hook

  add-zsh-hook preexec _update_title
  add-zsh-hook precmd _restore_title_cursor
}

# vim: set ts=2 sts=2 sw=2 ft=zsh et :
