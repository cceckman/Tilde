#!/bin/sh
# Set up Bash prompt.

. $HOME/scripts/repo.rc.sh

# Prompt color/look mods...
# Provide mapping here
COLOR="$THEME"
case "$COLOR" in
  blue)
    PROMPTCOL='\[\e[36m\]'
    ;;
  green)
    PROMPTCOL='\[\e[32m\]'
    ;;
  purple)
    PROMPTCOL='\[\e[35m\]'
    ;;
  red)
    PROMPTCOL='\[\e[91m\]'
    ;;
esac
ENDCOL='\[\e[0m\]'
PS1="$ENDCOL$PROMPTCOL∴ \$? \$(repo)\W \n∵ $ENDCOL"
export PS1
export CLICOLOR="Yes"
