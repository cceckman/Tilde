#!/bin/bash
# Provide local information on what color to use for prompts, etc.

# Default color
syscolor() { echo 'green'; }
source $HOME/secrets/syscolor.rc.sh
source $HOME/scripts/repo.rc.sh

# Prompt color/look mods...
# Provide mapping here
COLOR="$(syscolor)"
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
esac
ENDCOL='\[\e[0m\]'
PS1="$ENDCOL$PROMPTCOL(\A)[\$?] \$(repo)\W \$:$ENDCOL"
export PS1
export CLICOLOR="Yes"
