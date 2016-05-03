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
alias ls='ls -G --color=auto'
alias matrix='cmatrix -sab'
alias la='ls -lah'
alias vimc="vim *.cpp *.c *.h" # Edit all C/CPP files in the current directory
# alias e="vim"   #Because in vim, the command is e <filename>, so...
alias node="nodejs"
alias fixssh="source $HOME/scripts/fixssh" # see scripts/attach

# Fix OS X; use GNU grep if it's available.
# (Seriously, no PCRE support?)
if which ggrep >/dev/null 2>&1
then
  alias grep='ggrep'
fi

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

# Use $HOME/go for GOPATH / symlinks
if ! [[ "$GOPATH" == *"$HOME/go"* ]]
then
  if [[ "$GOTPAH" == "*:*" ]]
  then
    GOPATH="${GOPATH}:"
  fi
  GOPATH="${GOPATH}$HOME/go"
fi
export GOPATH

# Add some custom elements to PATH:
# scripts from Tilde repo; me-owned directories; CUDA; and `go`-built binaries.
ADDPATHS="$HOME/scripts $HOME/bin /usr/local/cuda/bin ${GOPATH//://bin:}/bin"
for addpath in $ADDPATHS
do
  if ! [[ "$PATH" == *"${addpath}"* ]]
  then
    PATH="${addpath}:$PATH"
  fi
done

# And to ensure CUDA is in the PATH:
export DYLD_LIBRARY_PATH="/usr/local/cuda/lib:${DYLD_LIBRARY_PATH}"

# Autocomplete Bazel commands.
if [ -e $HOME/.bazel/bin/bazel-complete.bash ]
then
  source $HOME/.bazel/bin/bazel-complete.bash
fi

# Set up window title
if echo "$TERM" | grep -Pq 'screen|xterm' 
then
	# Get correct escape sequence.
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
			screen*)
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

	# Get current branch, if any; followed by a colon.
	repo() {
		GIT=$(git branch --no-color 2>/dev/null | grep '[*]' | grep -o '[^* ]*')
		if [ $? -eq 0 ]
    then
      echo "$GIT:"
    fi
  }

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
  if ! echo "$PROMPT_COMMAND" | grep -Pq 'set_window_title' 
  then
    PROMPT_COMMAND="set_window_title; $PROMPT_COMMAND"
  fi
fi

# Enable vi mode; hit escape to use
set -o vi

# Typing is hard; use shell autocorrect, when available
if bash -o dirspell >/dev/null 2>&1
then
  shopt -s cdspell dirspell
fi

# Add prompt settings
source $HOME/.prompt.rc.sh

# Load a work profile, if any.
if [ -f $HOME/.work.rc.sh ]
then
  source $HOME/.work.rc.sh
fi

export PATH

# The next line updates PATH for the Google Cloud SDK.
source '/home/cceckman/Downloads/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/home/cceckman/Downloads/google-cloud-sdk/completion.bash.inc'
