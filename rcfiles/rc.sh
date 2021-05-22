#!/bin/sh
# vim: ft=sh

# Here's the bits I want for every machine...
. $HOME/rcfiles/portable.sh
# ...and here's the ones I want for customized-to-me machines.

# So that I'm always on "local" time
export TZ=America/Los_Angeles

# Keep this early, so subsequent includes can access THEME
if [ -x $HOME/scripts/syscolor ]
then
  export THEME="$($HOME/scripts/syscolor)"
else
  export THEME="red"
fi

alias gazelle="bazel run //:gazelle -- "
alias pgrep="pgrep -l"
alias z="exec zsh"
alias matrix="cmatrix -ab -C $THEME"

eixt() {
  echo "I think you mean 'exit'."
  echo "Well, I *hope* you mean 'exit'- here goes nothing..."
  sleep 0.5
  exit
}

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

e() {
  # Invoke the "current" editor
  if test "$TERM_PROGRAM" = "vscode"
  then
    code "$@"
  else
    vim "$@"
  fi
}

helpless() {
  "$@" --help 2>&1 | less
}

# This is only for Linux
alias copy='xclip -selection clipboard && echo '✂''
alias cbpaste='xclip -selection clipboard -o'

# Use $HOME/go for GOPATH.
if ! echo "$GOPATH" | grep -q "$HOME/go"
then
  if test -z "$GOPATH"
  then
    GOPATH="$HOME/go"
  else
    GOPATH="$GOPATH:$HOME/go"
  fi
fi
export GOPATH

export ARDUINO_PATH=/usr/local/arduino

# Add some custom elements to PATH:
# scripts from Tilde repo; me-owned directories; CUDA; and `go`-built binaries.
while read x
do
  case ":$PATH:" in
    *":$x:"*) :;;
    *) if test -d "$x";
       then
         PATH="$x:$PATH"
       fi
       ;;
  esac
done <<ADDPATHS
$HOME/.cargo/bin
$HOME/.local/bin
$HOME/bin
$GOPATH/bin
$HOME/scripts
/usr/local/go/bin
/usr/local/google-cloud-sdk/bin
ADDPATHS

export PATH

. $HOME/rcfiles/repo.sh

title() {
  # change the title of the current window or tab.
  # Default:
  if test "$#" -eq 0
  then
    title "$USER"@"$(hostname)"
    return
  fi

  # Use the XTerm code: https://tldp.org/HOWTO/Xterm-Title-3.html
  # but it seems to work for other graphical terminals as well.
  # Octally-encoded: <ESC>]0;<title><BELL>
  echo -ne "\033]0;$*\007"
}

# tmux management
parent() {
  # Get the parent process's command line.
  ps -p $(ps -p "$$" -o ppid=) -o cmd=
}

split() {
  # Open the current window manager... kind of.
  if parent | grep -q '^tmux'
  then
    tmux split-window "$1"
  else
    $HOME/scripts/term &
  fi
}
alias h="split -h"
alias v="split -v"

attach () {
  fixssh
  title "$1"
  tmux -u2 new-session -DA -s $1
  # Reset the title after exiting.
  title
}

ws () {
  r $1 && attach $(echo "$1" | tr ':.' '-')
}

predo() {
  redo -j$(nproc) "$@"
}

loadup() {
  fixssh
  addkeys
}

# Set title to user-at-host when starting a new shell.
title "$USER"@"$(hostname)"

ssh() {
  /usr/bin/ssh "$@"
  title
}
