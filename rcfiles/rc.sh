#!/bin/sh
# vim: ft=sh

# Posix-compatible shell initialization; so that it can be shared across bash/zsh/?

# So that I'm always on "local" time
export TZ=America/Los_Angeles

# Keep this early, so subsequent includes can access THEME
if [ -x $HOME/secrets/syscolor ]
then
  export THEME="$($HOME/secrets/syscolor)"
else
  export THEME="red"
fi

alias gazelle="bazel run //:gazelle -- "
alias pgrep="pgrep -l"
alias weechat="TERM=tmux-256color weechat"
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
  # Invoke 'vim' with some wrapping.
  vim "$@" && clear && pwd && echo "Done: $cmd"
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
$HOME/r/chromium/depot_tools
$HOME/scripts
$HOME/secrets/scripts
/usr/local/go/bin
/usr/local/google-cloud-sdk/bin
ADDPATHS

export PATH

. $HOME/rcfiles/repo.sh

ws () {
  r $1 && attach $(echo "$1" | tr ':.' '-')
}

. $HOME/rcfiles/portable.sh
