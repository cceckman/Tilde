# Aliases (for mnemonics etc) 
alias where='pwd'
alias makeLocalhost='python -m SimpleHTTPServer'
alias cl='clear; pwd; ls'
alias dir='ls' # In case I start using the windows CLI
alias del='rm'
alias matrix='cmatrix -sab'
alias la='ls -la'
alias pd="pushd"
alias gpp="g++"
alias vimc="vim *.cpp *.c *.h" # Edit all C/CPP files in the current directory
alias makelog="rm make.log; touch make.log; make > make.log & tail -f make.log"

# To use custom bash scripts in the Tilde repo...
PATH="$HOME/scripts:${PATH}"

# Prompt color/look mods...
PROMPTCOL='\[\e[32m\]'
ENDCOL='\[\e[0m\]'
PS1="$ENDCOL$PROMPTCOL(\A) \W \$:$ENDCOL"

export PATH  
export PS1

# Use the DirB directory bookmarks tool
source ~/.bashDirB
