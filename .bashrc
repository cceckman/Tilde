# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.
#if [ "$PS1" != "" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]
#then
#      STARTED_SCREEN=1 ; export STARTED_SCREEN
#        [ -d $HOME/lib/screen-logs ] || mkdir -p $HOME/lib/screen-logs
#          sleep 1
#            screen -RR && exit 0
#              # normally, execution of this rc script ends here...
#                echo "Screen failed! continuing with normal bash startup"
#            fi
            # [end of auto-screen snippet]

# Aliases (for mnemonics etc) 
alias where='pwd'
alias makeLocalhost='python -m SimpleHTTPServer'
alias cl='clear; pwd; ls'
alias ls='ls -G'
alias dir='ls' # In case I start using the windows CLI
alias del='rm'
alias matrix='cmatrix -sab'
alias la='ls -lah'
alias vimc="vim *.cpp *.c *.h" # Edit all C/CPP files in the current directory
# alias e="vim"   #Because in vim, the command is e <filename>, so...
alias node="nodejs"

mdcd() {
  # Make a directory, and move to it.
  mkdir -p $1 && cd $1
}

e() {
  # Invoke 'vim' with some wrapping.
  cmd="vim $@"
  $cmd && clear && pwd && echo "Done: $cmd"
}

# http://github.com/huyng/bashmarks - thanks, @huyng!
bashmarks="$HOME/scripts/bashmarks.sh"
if [ -e "$bashmarks" ]
then
  source $bashmarks
fi

# emacs isn't for everyone.
export EDITOR=vim

# This is only for Linux
# alias pbcopy='xclip -selection clipboard'
# alias pbpaste='xclip -selection clipboard -o'

# To use custom bash scripts from the Tilde repo...
ADDPATHS=$(echo <<EOD
$HOME/scripts
$HOME/bin
/usr/local/cuda/bin
EOD
)
for addpath in $ADDPATHS
do
  if ! [[ "$PATH" == "*${addpath}*" ]]
  then
    PATH="${addpath}:$PATH"
  fi
done
export PATH

# And to ensure CUDA is in the PATH:
export DYLD_LIBRARY_PATH="/usr/local/cuda/lib:${DYLD_LIBRARY_PATH}"

# Autocomplete Bazel commands.
if [ -e $HOME/.bazel/bin/bazel-complete.bash ]
then
  source $HOME/.bazel/bin/bazel-complete.bash
fi

# Prompt color/look mods...
PROMPTCOL='\[\e[32m\]'
ENDCOL='\[\e[0m\]'
PS1="$ENDCOL$PROMPTCOL(\A)[\$?] \W \$:$ENDCOL"

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

# Enable vi mode; hit escape to use
set -o vi

