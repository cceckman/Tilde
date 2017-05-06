#!/bin/bash
# Bash-only initialization / aliases.

. $HOME/rcfiles/rc.sh
. $HOME/rcfiles/prompt.bash

# http://github.com/huyng/bashmarks - thanks, @huyng!
bashmarks="$HOME/rcfiles/bashmarks/bashmarks.sh"
if [ -e "$bashmarks" ]
then
  source $bashmarks
fi

# Autocomplete Bazel commands.
if [ -e $HOME/.bazel/bin/bazel-complete.bash ]
then
  source $HOME/.bazel/bin/bazel-complete.bash
fi

# Add completion for repo
source $HOME/rcfiles/completerepo.bash

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
      screen*|tmux*)
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
    printf "${titlestart}%s${titlefinish}" "$HPWD"
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

echo "Friendly reminder: your default shell is not ZSH."
echo "Run 'sudo chsh -s \$(which zsh) \$USER' to change."
