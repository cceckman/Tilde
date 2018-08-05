#! /bin/sh
#
# Run or attach to ssh agent. Kill the agent on exit.

# part 1: get an agent
getagent() {
  stage="explicit"
  I=0
  while (ssh-add -l 2>/dev/null >/dev/null ; test "$?" -eq 2 )
  do
    echo "unable to connect to agent $SSH_AGENT_PID $SSH_AUTH_SOCK"
    case "$stage" in
      explicit)
        # TODO: look in ~/.ssh/agents for one that works instead
        stage=list;
        if test -e $HOME/scripts/sshsettings
        then
          echo "attaching to agent specified by ~/scripts/sshsettings"
          . $HOME/scripts/sshsettings
        fi
        ;;
      list)
        echo "looking for existing agents..."
        N=$(ls $HOME/.ssh/agents | wc -l)
        testAgent=$(ls $HOME/.ssh/agents | head -n-$I | tail -1)
        . $HOME/.ssh/agents/${testAgent}
        I=$((I + 1))
        if test $I -ge $N
        then
          stage=start
        fi
        ;;
      start)
        stage=end
        echo "starting ssh-agent for this session"
        eval `ssh-agent`
        # Annoying bit: zsh/posix compatibility, per
        # https://stackoverflow.com/questions/22793713/how-to-set-a-shell-exit-trap-from-within-a-function-in-zsh-and-bash
        if ! test -z "$ZSH_VERSION"
        then
          zshexit() {
            echo "killing ${SSH_AGENT_PID}"
            kill ${SSH_AGENT_PID}
          }
        else
          trap "kill ${SSH_AGENT_PID}" EXIT
        fi
        ;;
      end)
        echo >&2 "could not create or find ssh-agent!"
        return 1
        ;;
    esac
  done
}

writesshsettings() {
  # write current settings to file
  SSHV="SSH_CLIENT SSH_TTY SSH_AUTH_SOCK SSH_CONNECTION DISPLAY SSH_AGENT_PID"

  for x in ${SSHV} ; do
    echo export $x=\"$(eval echo \$$x)\"
  done 1>$HOME/scripts/sshsettings
}

addkeys() {
  if (ssh-add -l >/dev/null ; test "$?" -eq 1 )
  then
    echo "adding keys to agent $SSH_AGENT_PID"
    for key in $(ls $HOME/.ssh | grep '[.]pub$' | sed 's/.pub$//')
    do
      ssh-add -t 7200 $HOME/.ssh/${key}
    done
  fi
}

fixssh() {
  getagent && writesshsettings && addkeys
}

attach () {
  # From http://samrowe.com/wordpress/ssh-agent-and-gnu-screen/:
  # Attach to a tmux session, while forwarding SSH agent.

  fixssh
  tmux -u2 new-session -DA -s $1
}
