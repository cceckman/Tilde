#!/bin/zsh
# zsh initialization file.

# zmodload zsh/zprof

# Set up the prompt; allow substitutions.
set -o PROMPT_SUBST

# Use Vim keybindings in ZLE.
bindkey -v

setopt histignorealldups sharehistory extended_glob nonomatch

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# For ZSH auto-suggestions:
ZSH_AUTOSUGGEST_USE_ASYNC='yes, please! async is usually better.'
bindkey '^ ' autosuggest-accept # Because the right-arrow key is too far away.

# Enable $EDITOR to edit command line.
autoload -U edit-command-line
# Vi style:
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Allow comments in interactive scripts, e.g. if copy+pasted
setopt interactivecomments

