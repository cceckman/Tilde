#!/bin/sh
# vim: ft=sh

# Posix-compatible shell initialization; so that it can be shared across bash/zsh/?

# So that I'm always on "local" time
export TZ=America/Los_Angeles

alias cl='clear; pwd; ls'
alias g="git"
alias gazelle="bazel run //:gazelle -- "
alias la='ls -lah'
# Don't reach over for -
alias lesss="less -S"
alias md="mkdir"
alias mtr="mtr -t"
alias pgrep="pgrep -l"
alias weechat="TERM=tmux-256color weechat"
alias z="exec zsh"

eixt() {
  echo "I think you mean 'exit'."
  echo "Well, I *hope* you mean 'exit'- here goes nothing..."
  sleep 0.5
  exit
}

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

if which hub 2>&1 >/dev/null
then
  eval "$(hub alias -s)"
fi

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

# Fix OS X; only use --color=auto if on Linux.
if uname -a | grep -q '[dD]arwin'
then
  alias ls='ls -Gv'
else
  alias ls='ls -Gv --color=auto'
fi

mdcd() {
  # Make a directory, and move to it.
  mkdir -p $1 && cd $1
}

e() {
  # Invoke 'vim' with some wrapping.
  vim "$@" && clear && pwd && echo "Done: $cmd"
}

helpless() {
  "$@" --help 2>&1 | less
}

# emacs isn't for everyone.
export EDITOR=vim

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
ADDPATHS="$(if test -d $HOME/r/chromium/depot_tools; then echo "$HOME/r/chromium/depot_tools:"; fi)$HOME/secrets/scripts:$HOME/scripts:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:/usr/local/cuda/bin:/usr/lib/go-1.8/bin:/usr/local/go/bin:$(echo "$GOPATH" | sed -e 's-:-/bin:-' -e 's-$-/bin-' )"
echo "$ADDPATHS" | tr ':' '\n' | while read x
do
  case ":$PATH:" in
    *":$x:"*) :;;
    *) PATH="$x:$PATH";;
  esac
done

export PATH

if [ -x $HOME/secrets/syscolor ]
then
  export THEME="$($HOME/secrets/syscolor)"
else
  export THEME="red"
fi

alias matrix="cmatrix -ab -C $THEME"

. $HOME/rcfiles/repo.sh

ws () {
  r $1 && attach $(echo "$1" | tr ':.' '-')
}

. $HOME/rcfiles/s.sh
