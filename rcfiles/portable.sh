#! /bin/sh
#
# Portable shell config- to local or remote hosts.

# I like vi mode.
set -o vi
# emacs isn't for everyone.
export EDITOR=vim


export PS1="\$(printf '∴ %i %s@%s:%s\n∵ ' \$? \$USER \$(hostname) \$PWD)"
export CLICOLOR="Yes"

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

# Run or attach to an SSH agent.
fixssh() {
  stty sane

  if test "$1" = '-f'
  then
    FORCE=true
  else
    FORCE=false
  fi

  SOCKPATH="$HOME/.ssh/agent.sock"

  if test -n "$SSH_AUTH_SOCK" && ! "$FORCE"
  then
    echo >&2 "Looks like we already have an ssh-agent; not starting a new one."
    return 1
  fi

  if test -S "$SOCKPATH"
  then
    GOT_PERMS="$(stat -c '%a' "$SOCKPATH")"
    WANT_PERMS="600"
    if test "$GOT_PERMS" != "$WANT_PERMS"
    then
      echo >&2 "Refusing to adopt SSH agent via socket $SOCKPATH with permissions: $GOT_PERMS != $WANT_PERMS"
      return 1
    fi
    # Looks OK. Adopt the socket.
    SSH_AUTH_SOCK="$SOCKPATH"
  else
    # Launch a new agent.
    eval $(ssh-agent -a "$SOCKPATH")
  fi

  export SSH_AUTH_SOCK
}

addkeys() {
  echo "adding keys to agent $SSH_AGENT_PID"
  ssh-add -t 7200 $(ls $HOME/.ssh \
    | grep '[.]pub$' \
    | sed 's/.pub$//' \
    | sed "s!^!$HOME/.ssh/!" )
}

export SSH_AUTH_SOCK
