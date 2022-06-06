#!/usr/bin/env zsh
# Inspired by:
# github.com/ericfreese/zsh-efgit-prompt/blob/master/prompt_efgit_setup
# stackoverflow.com/questions/10564314/count-length-of-user-visible-string-for-zsh-prompt

setopt PROMPT_SUBST

# git prompt
() {
  # stolen from omz
  function __git() {
    GIT_OPTIONAL_LOCKS=0 command git "$@"
  }

  # stolen from omz
  function git_current_branch() {
    local ref=$(__git symbolic-ref --quiet HEAD 2> /dev/null)
    local ret=$?
    if [[ $ret != 0 ]]; then
      [[ $ret == 128 ]] && return
      ref=$(__git rev-parse --short HEAD 2> /dev/null) || return
    fi
    echo ${ref#refs/heads/}
  }

  _SYM_AHEAD="%{$fg[magenta]%}▲"
  _SYM_BEHIND="%{$fg[blue]%}▼"
  _SYM_STAGED="%{$fg[blue]%}"
  _SYM_UNSTAGED="%{$fg[red]%}"
  _SYM_UNTRACKED="%{$fg[cyan]%}"
  _SYM_UNMERGED="%{$fg[red]%}✕"

  # parse git infos
  function my_git_prompt() {
    local BRANCH="$(git_current_branch)"

    [[ -z $BRANCH ]] && return

    local staged unstaged untracked unmerged ahead behind STATUS
    __git status --porcelain --branch 2>/dev/null | while IFS= read; do
      case "$REPLY" in
        (D[ M]|[MARC][ MD])' '*)
          staged=1 ;|

        ([ MARC][MD])' '*)
          unstaged=1 ;|

        (A[AU]|D[DU]|U[ADU])' '*)
          unmerged=1 ;;

        '??'*)
          untracked=1 ;;

        '##'*ahead*)
          ahead=1 ;|

        '##'*behind*)
          behind=1 ;;
      esac
    done

    [[ -n $ahead     ]] && STATUS+="$_SYM_AHEAD"
    [[ -n $behind    ]] && STATUS+="$_SYM_BEHIND"
    [[ -n $staged    ]] && STATUS+="$_SYM_STAGED"
    [[ -n $unstaged  ]] && STATUS+="$_SYM_UNSTAGED"
    [[ -n $untracked ]] && STATUS+="$_SYM_UNTRACKED"
    [[ -n $unmerged  ]] && STATUS+="$_SYM_UNMERGED"
    [[ -n $STATUS    ]] && STATUS="($STATUS%f)%b"

    echo " on %B$BRANCH$STATUS%f%b"
  }
}

# ssh connection
() {
  [[ -n $SSH_CONNECTION ]] && _SSH="%{$fg_bold[red]%}(SSH) %k%f"
}

# path function
() {
  _PWD_PATH_COLOR="%{$fg[blue]%}"
  _PWD_PRE="in %B"
  _PWD_POST="%b"

  function show_path() {
    local _PWD

    if ((${#PWD} > 4*COLUMNS/5)); then
      _PWD="${${PWD/#$HOME/~}//(#b)([^\/])[^\/][^\/]#\//$match[1]/}"
    else
      _PWD="%~"
    fi

    echo -n "$_PWD_PRE$_PWD_PATH_COLOR$_PWD$_PWD_POST"
  }
}

# timer
() {
  _TIMER_FG=
  _TIMER_PRECISION=2 # number > 0
  _TIMER_MIN_S=0
  _TIMER_MIN_MS=1

  # current time since epoch
  function _now() {
    date +%s%${_TIMER_PRECISION}N
  }

  # save the time
  function _timer_start() {
    typeset -g _execution_start=$(_now)
  }

  # compute elapsed time
  function _timer_end() {
    typeset -g _execution_start _prompt_time

    [[ -z $_execution_start ]] && {
      unset _prompt_time
      return
    }

    _prompt_time=$(( $(_now) - $_execution_start ))
    unset _execution_start
  }

  # prompt timer content
  function _timer() {
    local s ms pp1=$((_TIMER_PRECISION + 1))

    [[ -z $_prompt_time ]] && return

    # Pad time if too short
    (( ${#_prompt_time} < pp1 )) && _prompt_time=${(l:$pp1::0:)_prompt_time}

    # TODO: convert in minute also
    s=${_prompt_time:0:-$_TIMER_PRECISION}
    ms=${_prompt_time#$s}

    (( s > _TIMER_MIN_S || (s == _TIMER_MIN_S && ms > ${(r:$_TIMER_PRECISION::0:)_TIMER_MIN_MS}) )) && \
      echo -n " took %B${_TIMER_FG}${s}.${ms}%bs"
  }
}

# prompt with async git
() {
  _BAD_RETURN="%(?.. yielded %B%{$fg[red]%}%?%b)"
  _BG_JOB="%1(j. with %B%{$fg[blue]%}jobs%b.)"
  _BAD_RETURN="%(?.. yielded %B%{$fg[red]%}%?%b)"
  _PROMPT_SYM='%B%(?..%{$fg[red]%}>)> %b'

  [[ $USER == root ]] && _USER="%B%{$fg[red]%}root%b "

  # update prompt vars
  function _update_prompt() {
    typeset -g _git_info="$1" _prompt_time

    function _len() {
      local zero='%([BSUbfksu]|([FK]|){*})'
      echo ${#${(S%%)1//$~zero/}}
    }

    local -a _contents=(
      "$_USER"
      "$_prompt_wd"
      "$_git_info"
      "$_BAD_RETURN"
      "$_BG_JOB"
      "$(_timer)"
    )

    RPROMPT=
    PROMPT=$'\n'

    for content in ${_contents[@]}; {
      (( $(_len "$PROMPT") + $(_len "$content") > COLUMNS )) \
        && RPROMPT+="$content" \
        || PROMPT+="$content"
    }

    PROMPT+=$'\n'
    PROMPT+="$_SSH"
    PROMPT+="$_PROMPT_SYM"
  }

  # zle prompt worker
  function _get_git_response() {
    typeset -g _prompt_git_fd

    _update_prompt "$(<&$1)"
    zle reset-prompt

    zle -F $1
    exec {1}<&-
    unset _prompt_git_fd
  }

  # prompt update
  function _prompt_precmd() {
    typeset -g _prompt_git_fd

    _update_prompt

    [[ -n $_prompt_git_fd ]] && {
      zle -F $_prompt_git_fd
      exec {_prompt_git_fd}<&-
    }

    exec {_prompt_git_fd}< <(my_git_prompt)
    zle -F $_prompt_git_fd _get_git_response
  }
}

# fish pwd update
function _update_wd() {
  typeset -g _prompt_wd="$(show_path)"
}

# resize hook
function _prompt_winch_redraw() {
  _update_wd
  _update_prompt "$_git_info"
  zle reset-prompt
}

# clear hook
function _clear() {
  unset _prompt_time
  _prompt_precmd
  zle clear-screen
  zle reset-prompt
}

# init
() {
  _update_wd

  autoload -U add-zsh-hook
  add-zsh-hook precmd  _prompt_precmd
  add-zsh-hook chpwd   _update_wd
  add-zsh-hook preexec _timer_start
  add-zsh-hook precmd  _timer_end

  zle -N _clear
  bindkey '^l' _clear

  trap _prompt_winch_redraw WINCH
}

# vim:set ts=8 sts=2 sw=2 et ft=zsh :
