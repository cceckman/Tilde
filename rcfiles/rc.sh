#!/bin/sh
# vim: ft=sh

# Posix-compatible shell initialization; so that it can be shared across bash/zsh/?

# So that I'm always on "local" time
export TZ=America/Los_Angeles

alias cl='clear; pwd; ls'
alias matrix='cmatrix -sab'
alias la='ls -lah'
alias fixssh=". $HOME/scripts/fixssh" # see scripts/attach
alias t="xterm &" # start a new terminal in the same directory
alias pgrep="pgrep -l"
# Per https://www.wisdomandwonder.com/link/7784/making-irssi-refresh-work-with-tmux
# Fix irssi scrolling with tmux
alias irssi="TERM=screen irssi"

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
  cmd="vim $@"
  $cmd && clear && pwd && echo "Done: $cmd"
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

# Add some custom elements to PATH:
# scripts from Tilde repo; me-owned directories; CUDA; and `go`-built binaries.
ADDPATHS="$HOME/secrets/scripts:$HOME/scripts:$HOME/.cargo/bin:$HOME/bin:/usr/local/cuda/bin:/usr/local/go/bin:$(echo "$GOPATH" | sed -e 's-:-/bin:-' -e 's-$-/bin-' )"
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

. $HOME/rcfiles/repo.sh

ws () {
  r $1 || {
    echo "repository $1 not found" && return 1
  }
  attach $1
}
