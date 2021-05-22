#!/bin/zsh
# zsh initialization file.

# zmodload zsh/zprof

# Load Posix-compatible bits at startup.
. $HOME/rcfiles/rc.sh

# Set up the prompt.
set -o PROMPT_SUBST
. $HOME/rcfiles/prompt.zsh

if test -e $HOME/rcfiles/work.rc.sh
then
  . $HOME/rcfiles/work.rc.sh
fi

# Include my own functions.
fpath+=($HOME/.zsh_functions)

# Use Vim keybindings in ZLE.
bindkey -v

setopt histignorealldups sharehistory extended_glob nonomatch

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use history for zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_USE_ASYNC='yes, please! async is usually better.'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$THEME"
bindkey '^ ' autosuggest-accept # Because the right-arrow key is too far away.

# Enable $EDITOR to edit command line.
autoload -U edit-command-line
# Vi style:
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

if [ -f "$HOME/rcfiles/gcloud.zsh" ]; then source "$HOME/rcfiles/gcloud.zsh"; fi

# Allow comments in interactive scripts, e.g. if copy+pasted
setopt interactivecomments

