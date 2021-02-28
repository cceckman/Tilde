#!/bin/zsh
# Set up ZSH prompt.
#
. $HOME/rcfiles/repo.sh

if test "$THEME" = "red"
then
  _HOSTSTR="%n@%m "
else
  _HOSTSTR=""
fi


# Prompt color/look mods...
PS1="%f%k%F{$THEME}∴ \$? $_HOSTSTR\$(_repo)%1~
∵ %f"
export PS1
export CLICOLOR="Yes"
