#!/bin/zsh
# zsh initialization file.
# Assume we're coming here from the "portable" configuration.

# zmodload zsh/zprof

# Set up the prompt.
set -o PROMPT_SUBST
if test -e "$HOME"/rcfiles/prompt.zsh
then
  . "$HOME"/rcfiles/prompt.zsh
fi

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
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$SYSCOLOR"
bindkey '^ ' autosuggest-accept # Because the right-arrow key is too far away.

# Enable $EDITOR to edit command line.
autoload -U edit-command-line
# Vi style:
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Allow comments in interactive scripts, e.g. if copy+pasted
setopt interactivecomments

