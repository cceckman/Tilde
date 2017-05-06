#!/bin/zsh
# Set up ZSH prompt.
#
. $HOME/scripts/repo.rc.sh

# Prompt color/look mods...
PS1="%f%k%F{$THEME}∴ \$? \$(repo)%~
∵ %f"
export PS1
export CLICOLOR="Yes"
