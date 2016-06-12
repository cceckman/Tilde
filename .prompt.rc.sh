source $HOME/scripts/syscolor

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
PS1="$ENDCOL$PROMPTCOL(\A)[\$?] \W \$:$ENDCOL"
export PS1
export CLICOLOR="Yes"
