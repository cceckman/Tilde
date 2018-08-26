#! /bin/sh
#
# Run or attach to GPG/SSH agent.

fixssh() {
  stty sane
  GPG_TTY=$(tty)
  export GPG_TTY

  if test -S "$HOME/.gnupg/S.gpg-agent.remote"
  then
    # Agent forwarding enabled.
    # Forward the local version.
    ln -s "$HOME/.gnupg/S.gpg-agent.remote" "$(gpgconf --list-dir socketdir)/S.gpg-agent" 2>&1 >/dev/null
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
# 'fixssh' upon entering a shell
fixssh
