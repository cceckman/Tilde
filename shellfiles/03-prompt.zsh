#!/bin/zsh
# Set up ZSH prompt.

set -o PROMPT_SUBST

if test "$SYSCOLOR" = "red"
then
  _HOSTSTR="%n@%m "
else
  _HOSTSTR=""
fi


# Prompt color/look mods...
PS1="%f%k%F{$SYSCOLOR}∴ \$? $_HOSTSTR\$(_repo)%1~
∵ %f"
export PS1
export CLICOLOR="Yes"
