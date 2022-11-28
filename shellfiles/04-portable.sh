#! /bin/sh
#
# Portable shell config- to local or remote hosts.

# I like vi mode.
set -o vi
# emacs isn't for everyone.
export EDITOR=vim

## Common aliases
alias cl='clear; pwd; ls'
alias la='ls -lah'
# Don't reach over for -
alias lesss="less -S"
alias md="mkdir"
alias g="git"
alias mtr="mtr --curses"

if ls -v >/dev/null 2>&1
then
  LSARGS="$LSARGS -v"
fi
if ls --color=auto >/dev/null 2>&1
then
  LSARGS="$LSARGS --color=auto"
fi
alias ls="ls $LSARGS"

mdcd() {
  # Make a directory, and move to it.
  mkdir -p $1 && cd $1
}

s() {
  # ls or cat? Now you don't have to choose!
  for arg in "$@"
  do
    if test -d "$arg"
    then
      ls "$arg"
    else
      cat "$arg"
    fi
  done
}

