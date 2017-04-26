# So that I'm always on "local" time
export TZ=America/Los_Angeles

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

# Enable ssh-agent with keychain.
#if [[ -z "$SSH_AUTH_SOCK" ]]
#then
#  eval $( keychain --eval --quiet --timeout 15 id_ed25519 id_rsa)
#fi

alias where='pwd'
alias makeLocalhost='python -m SimpleHTTPServer'
alias cl='clear; pwd; ls'
alias matrix='cmatrix -sab'
alias la='ls -lah'
alias vimc="vim *.cpp *.c *.h" # Edit all C/CPP files in the current directory
# alias e="vim"   #Because in vim, the command is e <filename>, so...
alias node="nodejs"
alias fixssh="source $HOME/scripts/fixssh" # see scripts/attach
alias t="xterm &" # start a new terminal in the same directory
# Try to use 256 colors with tmux.
alias tmux='tmux -2'
alias pgrep="pgrep -l"

ce() {
  if test "$#" -gt 0
  then
    git commit -a -m "$@"
  else
    git commit -a
  fi
  git push
}

ca() {
  git commit -a -m "$@"
}

# git root; or git-root push
gr() {
  if ! base="$(git rev-parse --show-toplevel)"
  then
    echo "Not under Git?"
    return
  fi
  if [ "$1" == "p" ]
  then
    pushd "$base"
  else
    cd "$base"
    pwd
  fi
}

# Fix OS X; only use --color=auto if on Linux.
case "$OSTYPE" in
  darwin*)
    alias ls='ls -Gv'
    ;;
  *)
    alias ls='ls -Gv --color=auto'
    ;;
esac

mdcd() {
  # Make a directory, and move to it.
  mkdir -p $1 && cd $1
}

e() {
  # Invoke 'vim' with some wrapping.
  cmd="vim $@"
  $cmd && clear && pwd && echo "Done: $cmd"
}

vncssh() {
  # VNC to a machine over an SSH tunnel.
  # Assumes the setup in "distro", that is, xvnc.socket
  ssh $1 -L 8900:localhost:5900
  vinagre localhost:8901
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
alias copy='xclip -selection clipboard'
alias cbpaste='xclip -selection clipboard -o'

# Use $HOME/go for GOPATH / symlinks
if ! [[ "$GOPATH" == *"$HOME/go"* ]]
then
  if [[ "$GOPATH" != "" ]]
  then
    GOPATH="${GOPATH}:"
  fi
  GOPATH="${GOPATH}$HOME/go"
fi
export GOPATH

# Add some custom elements to PATH:
# scripts from Tilde repo; me-owned directories; CUDA; and `go`-built binaries.
ADDPATHS="$HOME/scripts $HOME/.cargo/bin $HOME/bin /usr/local/cuda/bin /usr/local/go/bin ${GOPATH//://bin:}/bin"
for addpath in $ADDPATHS
do
  # If-guard to reduce PATH-resolution times.
  if ! [[ "$PATH" == *"${addpath}"* ]]
  then
    PATH="${addpath}:$PATH"
  fi
done

if [[ $LD_LIBRARY_PATH != */usr/local/lib/:* ]]
then
  LD_LIBRARY_PATH="/usr/local/lib/:${LD_LIBRARY_PATH}"
fi

# Autocomplete Bazel commands.
if [ -e $HOME/.bazel/bin/bazel-complete.bash ]
then
  source $HOME/.bazel/bin/bazel-complete.bash
fi

# Add scripts for prompt and repo functions
source $HOME/scripts/repo.rc.sh
source $HOME/scripts/prompt.rc.sh

# Set up window title
if echo "$TERM" | grep -q 'screen\|xterm\|tmux'
then
  # Get correct escape sequence for 'title'.
  # Thanks to Mikel++, from
  # http://unix.stackexchange.com/questions/7380/force-title-on-gnu-screen
  terminit() {
      # determine the window title escape sequences
      case "$TERM" in
      aixterm|dtterm|putty|rxvt|xterm*)
          titlestart='\033]0;'
          titlefinish='\007'
          ;;
      cygwin)
          titlestart='\033];'
          titlefinish='\007'
          ;;
      konsole)
          titlestart='\033]30;'
          titlefinish='\007'
          ;;
      screen|tmux*)
          # status line
          #titlestart='\033_'
          #titlefinish='\033\'
          # window title
          titlestart='\033k'
          titlefinish='\033\'
          ;;
      *)
          if type tput >/dev/null 2>&1
          then
              if tput longname >/dev/null 2>&1
              then
                  titlestart="$(tput tsl)"
                  titlefinish="$(tput fsl)"
              fi
          else
              titlestart=''
              titlefinish=''
          fi
          ;;
      esac
  }
  terminit
  set_window_title () {
    local HPWD="$PWD"
    case $HPWD in 
        $HOME)
          HPWD="~"
          ;;
        *)
          HPWD=$(basename "$HPWD")
          ;; 
    esac
    printf "${titlestart}%s${titlefinish}" "$(repo)$HPWD"
  }
  if ! echo "$PROMPT_COMMAND" | grep -q 'set_window_title'
  then
    PROMPT_COMMAND="set_window_title; $PROMPT_COMMAND"
  fi
fi

# Enable vi mode; hit escape to use
set -o vi

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Typing is hard; use shell autocorrect, when available
if bash -o dirspell >/dev/null 2>&1
then
  shopt -s cdspell dirspell
fi

# Load a work profile, if any.
# Load it last, so that it can ovverride the above as needed.
if [ -f $HOME/.work.rc.sh ]
then
  source $HOME/.work.rc.sh
fi

export PATH

