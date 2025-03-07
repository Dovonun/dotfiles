# Created by newuser for 5.9

autoload -U add-zsh-hook
setopt HIST_IGNORE_ALL_DUPS
unsetopt PROMPT_SP

bindkey "^R" history-incremental-search-backward
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

source $ZDOTDIR/completion.zsh

function create_rprompt {
  STATUS=$1
  ERROR=''
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ $STATUS -ne 0 ]]; then
    ERROR="%F{red}$STATUS%f"
  fi

  if [[ -n $BRANCH ]]; then
    BRANCH="%F{cyan}$BRANCH%f"
  fi

  if [[ -n $ERROR && -n $BRANCH ]]; then
    echo "$ERROR | $BRANCH"
  else
    echo $ERROR$BRANCH
  fi
}

source $ZDOTDIR/alias.zsh

setopt prompt_subst
PROMPT='%F{cyan}%2~ >%f '
RPROMPT='$(create_rprompt $?)'

#zoxide
eval "$(zoxide init zsh)"


function osc7-pwd() {
    emulate -L zsh # ensure no side effects on global settings
    setopt extendedglob # enable extended pattern matching features
    local LC_ALL=C # make sure the locale doesn't interfere with encoding
    
    # Output OSC-7 escape sequence with hostname and URL-encoded current working directory
    printf '\e]7;file://%s%s\e\\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

function chpwd-osc7-pwd() {
    # Prevent recursive calls in subshells
    (( ZSH_SUBSHELL )) || osc7-pwd
}

# Hook the function so that it runs every time the directory changes
add-zsh-hook -Uz chpwd chpwd-osc7-pwd

# Ensure the OSC-7 function runs when a new terminal instance is started
osc7-pwd

