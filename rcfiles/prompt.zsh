#!/bin/zsh
# Set up ZSH prompt.
#
. $HOME/rcfiles/repo.sh

# Prompt color/look mods...
PS1="%f%k%F{$THEME}∴ \$? \$(repo)%1~
∵ %f"
export PS1
export CLICOLOR="Yes"
