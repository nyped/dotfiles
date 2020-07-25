if cat ~/.config/termite/config | grep day > /dev/null 2>&1; then
	export B1=221	B2=222	B3=223	B4=220
else
	export B1=024	B2=025	B3=031	B4=027
fi

function BUBBLE_PREFIX() {
	eval c=$"B$1"
	echo "%{$FG[$c]%}%{$BG[$c]%}%f"
}

function BUBBLE_SUFFIX() {
	eval c=$"B$1"
	echo "%k%{$FG[$c]%}%f"
}

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
    STATUS=" $STATUS"
  fi

  echo " $(BUBBLE_PREFIX 2)$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$(BUBBLE_SUFFIX 2)"
}

function my_current_branch() {
  echo $(git_current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "$(BUBBLE_PREFIX 4)ssh$(BUBBLE_SUFFIX 4) "
  fi
}

local ret_status="%(?..%{$fg_bold[red]%}%?%{$reset_color%})"
PROMPT=$'\n$(ssh_connection)$(BUBBLE_PREFIX 1)%n%{$FG[white]%}@%f%m$(BUBBLE_SUFFIX 1)$(my_git_prompt) $(BUBBLE_PREFIX 3)%~$(BUBBLE_SUFFIX 3)\n${ret_status} %# '

ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[blue]%}↓"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[blue]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✕"