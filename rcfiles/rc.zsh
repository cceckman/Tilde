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
if test -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_USE_ASYNC='yes, please!'
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$SYSCOLOR"
  bindkey '^ ' autosuggest-accept # Because the right-arrow key is too far away.
fi

# Enable $EDITOR to edit command line.
autoload -U edit-command-line
# Vi style:
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Allow comments in interactive scripts, e.g. if copy+pasted
setopt interactivecomments

# Give systemd our local variables- in particular, our improved PATH
systemctl --user import-environment PATH

# Finally: if we're not in a graphical environment, launch sway
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  export XDG_SESSION_TYPE=wayland
  # https://github.com/swaywm/sway/pull/4876#issuecomment-1332403978
  export XDG_CURRENT_DESKTOP=sway
  exec sway
fi
