# Prompt color/look mods...
PROMPTCOL='\[\e[32m\]'
ENDCOL='\[\e[0m\]'
PS1="$ENDCOL$PROMPTCOL(\A)[\$?] \W \$:$ENDCOL"
export PS1
export CLICOLOR="Yes"
