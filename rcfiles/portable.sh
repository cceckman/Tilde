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

# Run or attach to GPG/SSH agent.
fixssh() {
  stty sane
  GPG_TTY=$(tty)
  export GPG_TTY

  if test -S "$HOME/.gnupg/S.gpg-agent.remote"
  then
    # Agent forwarding enabled.
    # Forward the local version.
    agent="$(gpgconf --list-dir socketdir)/S.gpg-agent"
    rm -rf "$agent"
    ln -s "$HOME/.gnupg/S.gpg-agent.remote" "$agent" 2>&1 >/dev/null
  fi

  echo UPDATESTARTUPTTY | gpg-connect-agent --no-autostart 2>&1 >/dev/null

  if test -z "$SSH_AUTH_SOCK"
  then
    # Create a gpg-agent and use its SSH-agent.
    eval $(gpg-agent --daemon)
    SSH_AUTH_SOCK=$(gpgconf --list-dir agent-ssh-socket | tr -d '\n')
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
