#! /bin/sh
#
# Run or attach to GPG/SSH agent.

fixssh() {
  stty sane
  GPG_TTY=$(tty)
  export GPG_TTY
  echo UPDATESTARTUPTTY | gpg-connect-agent 2>&1 >/dev/null

  if test -z "$SSH_AUTH_SOCK"
  then
    # Create a gpg-agent and use its SSH-agent.
    eval $(gpg-agent --daemon)
    SSH_AUTH_SOCK=$(gpgconf --list-dir agent-ssh-socket)
  fi

  ssh-add -L 2>&1 >/dev/null && {
    echo "ssh-add found keys using SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
    return
  }
  echo "no SSH agent found"
}

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

# 'fixssh' upon entering a shell
fixssh
