function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return

  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(git_current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is branch behind?
  if $(echo "$(git log HEAD..origin/$(git_current_branch) 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi

  # is anything staged?
  if $(echo "$INDEX" | command grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | command grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | command grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS="($STATUS%f)%b"
  fi

  echo "on %B$(my_current_branch)$STATUS%f%b"
}

function my_current_branch() {
  echo $(git_current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(SSH)%k%f"
  fi
}

function show_path() {
  if [[ ${#PWD} -gt "$(($COLUMNS/2))" ]]; then
    if [[ ${#PWD:t} -gt "$(($COLUMNS/2))" ]]; then
      # fish like wd but with shrinked tail
      echo \ in \%B${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}}//\/~/\~}/${${PWD:t}:0:10}%b...%B${${PWD:t}:$((${#PWD:t}-10)):10}
    else
      # fish like wd with expanded tail
      echo \ in \%B${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
    fi
  else
    # full size wd (ommit home dir)
    [[ $PWD = /home/$(whoami) ]] || echo \ in \%B%~
  fi
}

ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[blue]%}↓"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[blue]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✕"

RPROMPT_BAD_RETURN="%{$fg_bold[red]%}%?%b"
RPROMPT_BG_JOB="%{$fg_bold[blue]%}+%b"

PROMPT=$'\n'
PROMPT+="$(ssh_connection)"
PROMPT+="%B%(?. > . >> )%b"
RPROMPT='$(my_git_prompt)$(show_path)%b'
RPROMPT+="%(?.%1(j.%B[%b$RPROMPT_BG_JOB%B]%b.).%B[%b$RPROMPT_BAD_RETURN%1(j.$RPROMPT_BG_JOB.)%B]%b)"

# vim:set ts=8 sts=2 sw=2 et syn=sh :
