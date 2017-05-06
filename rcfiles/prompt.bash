#!/bin/bash
# Set up Bash prompt.

. $HOME/rcfiles/repo.sh

# Prompt color/look mods...
# Provide mapping here
case "$THEME" in
  cyan)
    PROMPTCOL='\[\e[36m\]'
    ;;
  green)
    PROMPTCOL='\[\e[32m\]'
    ;;
  magenta)
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