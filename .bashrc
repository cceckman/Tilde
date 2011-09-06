# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.
if [ "$PS1" != "" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]
then
      STARTED_SCREEN=1 ; export STARTED_SCREEN
        [ -d $HOME/lib/screen-logs ] || mkdir -p $HOME/lib/screen-logs
          sleep 1
            screen -RR && exit 0
              # normally, execution of this rc script ends here...
                echo "Screen failed! continuing with normal bash startup"
            fi
            # [end of auto-screen snippet]

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

# To use custom bash scripts in the Tilde repo...
PATH="$HOME/scripts:${PATH}"

# Prompt color/look mods...
PROMPTCOL='\[\e[34m\]'
ENDCOL='\[\e[0m\]'
PS1="$ENDCOL$PROMPTCOL(\A) \W \$:$ENDCOL"

export PATH  
export PS1

# Use the DirB directory bookmarks tool
source ~/.bashDirB
