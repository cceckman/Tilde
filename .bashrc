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
alias ls='ls -G'
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
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC' # I'm mostly on OS X;
                                                     # should figure out a way
                                                     # to have if/thens in here
alias ltspice="wine ~/dev/wineprogs/ltspice/scad3.exe"

# This is only for Linux
# alias pbcopy='xclip -selection clipboard'
# alias pbpaste='xclip -selection clipboard -o'

# To use custom bash scripts in the Tilde repo...
PATH="$HOME/scripts:${PATH}"
LD_LIBRARY_PATH="/usr/local/lib/:${LD_LIBRARY_PATH}"

# To use the Cool interpreter...
PATH="$HOME/dev/cool:${PATH}"

# Prompt color/look mods...
PROMPTCOL='\[\e[32m\]'
ENDCOL='\[\e[0m\]'
PS1="$ENDCOL$PROMPTCOL(\A) \W \$:$ENDCOL"

PYTHONSTARTUP="~/.profile.py"

export CLICOLOR="Yes"

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
