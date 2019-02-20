#! /bin/sh
#
# Portable shell config- to local or remote hosts.


## Common aliases
alias cl='clear; pwd; ls'
alias la='ls -lah'
# Don't reach over for -
alias lesss="less -S"
alias md="mkdir"
alias g="git"
alias mtr="mtr --curses"
alias make="/usr/bin/make -j $(grep -c '^processor' /proc/cpuinfo)"

# Fix OS X; only use --color=auto if on Linux.
if uname -a | grep -q '[dD]arwin'
then
  alias ls='ls -v'
else
  alias ls='ls -v --color=auto'
fi

mdcd() {
  # Make a directory, and move to it.
  mkdir -p $1 && cd $1
}

# emacs isn't for everyone.
export EDITOR=vim


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
  # From http://samrowe.com/wordpress/ssh-agent-and-gnu-screen/:
  # Attach to a tmux session, while forwarding SSH agent.
  fixssh
  tmux -u2 new-session -DA -s $1
}

addkeys() {
  echo "adding keys to agent $SSH_AGENT_PID"
  ssh-add -t 7200 $(ls $HOME/.ssh \
    | grep '[.]pub$' \
    | sed 's/.pub$//' \
    | sed "s!^!$HOME/.ssh/!" )
}

export SSH_AUTH_SOCK
