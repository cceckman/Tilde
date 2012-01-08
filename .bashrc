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
alias e="vim"   #Because in vim, the command is e <filename>, so...
alias gitup="git commit -a ; git push"   # Commit and upload

# To use custom bash scripts in the Tilde repo...
PATH="$HOME/scripts:${PATH}"
LD_LIBRARY_PATH="/usr/local/lib/:${LD_LIBRARY_PATH}"

# Prompt color/look mods...
PROMPTCOL='\[\e[32m\]'
ENDCOL='\[\e[0m\]'
PS1="$ENDCOL$PROMPTCOL(\A) \W \$:$ENDCOL"

export PATH  
export PS1

if [ "$TERM" = "screen" ]; 
then
  screen_set_window_title () {
      local HPWD="$PWD"
      case $HPWD in 
          $HOME) HPWD="~";;
          *) HPWD=`basename "$HPWD"`;; 
    esac
    printf '\ek%s\e\\' "$HPWD"
    }
    PROMPT_COMMAND="screen_set_window_title; $PROMPT_COMMAND"
fi


# Use the DirB directory bookmarks tool
source ~/.bashDirB
