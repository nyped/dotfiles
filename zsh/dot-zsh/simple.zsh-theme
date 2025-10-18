#!/usr/bin/env zsh
# Inspired by:
# https://github.com/ericfreese/zsh-efgit-prompt/blob/master/prompt_efgit_setup

setopt PROMPT_SUBST KSH_GLOB

# GIT stuff
() {
  # stolen from omz
  function __git() {
    GIT_OPTIONAL_LOCKS=0 command git "$@"
  }

  # stolen from omz
  function git_current_branch() {
    local ref
    ref="$(__git symbolic-ref --quiet HEAD 2>/dev/null)" || {
      # detached
      ref=$(__git rev-parse --short HEAD 2>/dev/null) || return
    }
    echo -n ${ref#refs/heads/}
  }

  _SYM_AHEAD="%F{magenta}▲"
  _SYM_BEHIND="%F{blue}▼"
  _SYM_STAGED="%F{blue}+"
  _SYM_UNSTAGED="%F{red}~"
  _SYM_UNTRACKED="%F{cyan}?"
  _SYM_UNMERGED="%F{red}✕"

  # parse git infos
  function my_git_prompt() {
    local BRANCH="$(git_current_branch)"

    [[ -z $BRANCH ]] && return

    local staged unstaged untracked unmerged ahead behind STATUS
    __git status --porcelain --branch 2>/dev/null | while IFS= read
    do
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

    echo -n " on %B$BRANCH$STATUS%f%b"
  }
}

# SSH stuff
[[ -n $SSH_CONNECTION ]] && {
  _SSH="%B%F{red}(SSH) %k%b%f"
  _SSH_TITLE_PREF="$USER@$HOST: "
}

# PATH stuff
() {
  _PWD_PATH_COLOR="%B%F{blue}"
  _PWD_PRE="in "
  _PWD_POST="%b%f"

  function show_path() {
    local _PWD

    if [[ $USER == root ]]; then
      if ((${#PWD} > 4*COLUMNS/5)); then
        _PWD="${${PWD}//(#b)([^\/])[^\/][^\/]#\//$match[1]/}"
      else
        _PWD="%/"
      fi
    else
      if ((${#PWD} > 4*COLUMNS/5)); then
        _PWD="${${PWD/#$HOME/~}//(#b)([^\/])[^\/][^\/]#\//$match[1]/}"
      else
        _PWD="%~"
      fi
    fi

    echo -n "$_PWD_PRE$_PWD_PATH_COLOR$_PWD$_PWD_POST"
  }
}

# timer stuff
() {
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

    s=${_prompt_time:0:-$_TIMER_PRECISION}
    ms=${_prompt_time#$s}

    (( s > _TIMER_MIN_S
      || (s == _TIMER_MIN_S && ms > ${(r:$_TIMER_PRECISION::0:)_TIMER_MIN_MS}) )) && {
      local -i min mimutes
      (( min = s / 60 ))
      (( s = s % 60 ))
      (( min > 0 )) && minutes="${min}%bmin %B"
      echo -n " took %B%F{cyan}${minutes}${s}.${ms}%bs%f"
    }
  }
}

# Prompt update function
() {
  _BG_JOB="%1(j. with %B%F{green}jobs%b%f.)"
  _BAD_RETURN="%(?.. returned %B%F{red}%?%b%f)"
  _PROMPT_SYM='%B%(?..%F{red}%(!.#.>))%(!.#.>) %b%f'
  _USER="%(!.%B%F{red}%n%b%f@%B%F{green}%M%b%f .)"
  [[ $USER != root && -n $_SSH ]] && \
    _USER="%B%F{yellow}%n%b%f@%B%F{green}%M%b%f "

  function _len() {
    echo -n "${#${${(%S)1}//[[:cntrl:]]'['+([[:digit:]])[[:alpha:]]/}}"
  }

  _AWAIT_GIT=' %B...%b'

  # update prompt vars
  function _update_prompt() {
    typeset -g _async_prompt_part _bad_return _bg_job

    case "$1" in
      reset)
        _async_prompt_part="$_AWAIT_GIT"
        ;;

      update)
        [[ $_async_prompt_part == "$_AWAIT_GIT" ]] && _async_prompt_part=
        _async_prompt_part+="$2"
        ;;

      *)
        return
        ;;
    esac

    local -a _contents=(
      "$_USER"
      "$_prompt_wd"
      "$_async_prompt_part"
      "$_bad_return"
      "$_bg_job"
      "$(_timer)"
    )

    RPROMPT=
    PROMPT=$'\n'

    local -i lp=0 lc
    for content in ${_contents[@]}; {
      lc=$(_len "$content")
      if (( lp + lc <= COLUMNS )); then
        PROMPT+="$content"
        (( lp+=lc ))
      else
        RPROMPT+="$content"
      fi
    }

    PROMPT+=$'\n'
    PROMPT+="$_SSH"
    PROMPT+="$_EXTRA_PROMPT"
    PROMPT+="$_PROMPT_SYM"

    # add time if RPROMPT is empty
    # [[ -z $RPROMPT ]] && RPROMPT="%b%F{black}%@"
  }
}

# Async tools
() {
  function _async_worker() {
    typeset -g _async_fd

    _update_prompt update "$(<&$1)"
    zle reset-prompt

    zle -F $_async_fd
    exec {_async_fd}<&-
    unset _async_fd

    typeset -g init=1
  }

  function _hooks_caller() {
    my_git_prompt
  }

  function _prompt_async_precmd() {
    typeset -g _async_fd

    # Reset the prompt
    _update_prompt reset

    [[ -n $_async_fd ]] && {
      zle -F $_async_fd
      exec {_async_fd}<&-
      unset _async_fd
    }

    # Call all the hooks
    exec {_async_fd}< <(_hooks_caller)
    zle -F $_async_fd _async_worker
  }
}

# fish pwd update
function _update_wd() {
  typeset -g _prompt_wd="$(show_path)"
}

# resize hook
function _prompt_winch_redraw() {
  typeset -g init
  [[ -z $init ]] && return  # Only if init

  _update_wd
  _update_prompt update
  zle && zle reset-prompt  # Only if active
}

# clear hook
function _clear() {
  unset _prompt_time

  # Clear
  if [[ -z $_IN_WSL ]]; then
    zle clear-screen
  else
    clear
  fi

  # Update git
  _prompt_async_precmd
}

# Update zsh conditionnal
function _update_cond_expr() {
  typeset -g _bad_return="${(%)_BAD_RETURN}"
  typeset -g _bg_job="${(%)_BG_JOB}"

  # Adding lenght informations
  _bad_return="%$(_len "$_bad_return"){${_bad_return}%}"
  _bg_job="%$(_len "$_bg_job"){${_bg_job}%}"
}

# Init the prompt
function _pre_prompt() {
  typeset -g _EXTRA_PROMPT=
}

# OneAPI prompt
function _intel_prompt() {
  if [[ -n $ONEAPI_ROOT ]]; then
    _EXTRA_PROMPT+="%B%F{cyan}[oneAPI]%k%b%f "
  fi
}

# Check for venv
function _venv_prompt() {
  typeset -g _EXTRA_PROMPT

  if [[ -n $VIRTUAL_ENV_PROMPT ]]; then
    _EXTRA_PROMPT+="%B%F{green}($VIRTUAL_ENV_PROMPT)%b%f "
  elif [[ -n $VIRTUAL_ENV ]]; then
    _EXTRA_PROMPT+="%B%F{green}(venv)%b%f "
  fi
}

# init
() {
  _update_wd

  autoload -U add-zsh-hook
  add-zsh-hook precmd  _pre_prompt
  add-zsh-hook precmd  _venv_prompt
  add-zsh-hook precmd  _intel_prompt
  add-zsh-hook precmd  _timer_end
  add-zsh-hook precmd  _update_cond_expr
  add-zsh-hook precmd  _prompt_async_precmd
  add-zsh-hook chpwd   _update_wd
  add-zsh-hook preexec _timer_start

  zle -N _clear
  bindkey '^l' _clear

  trap _prompt_winch_redraw WINCH
}

# vim:set ts=8 sts=2 sw=2 et ft=zsh :
