#! /bin/sh
#
# Set up a Debian machine to my liking.

set -eu

stderr() {
  echo >&2 "$@"
}

usage() {
  stderr "$0 [--local] [<hostname>]"
  stderr "  Configure localhost or <hostname> with customizations."
  stderr "  If --local, prepare the machine for local use."
  # TODO: --user to create a cceckman-as-root user.
  exit 1
}


# Start by parsing arguments.
TARGET=""
LOCAL="false"

parse_args() {
  for ARG in "$@"
  do
    case "$ARG" in
      "--local")
        LOCAL=true
        ;;
      "--"*)
        stderr "Unrecognized flag $ARG"
        usage
        ;;
      *)
        if test -z "$TARGET"
        then
          TARGET="$ARG"
        else
          stderr "Multiple targets specified"
        fi
        ;;
    esac
  done

}

# If we're bootstrapping via SSH - copy ourselves, then bootstrap locally.
bounce() {
  test -n "$TARGET"
  mkdir -p "$HOME"/.tmp
  local SOCK
  SOCK="$(mktemp -p "$HOME"/.tmp/ -d )/setup-ssh.sock"
  SSHOPTS="-o ControlPersist=2 -o ControlPath='$SOCK'"

  # Reproduce arguments other than $TARGET
  LOCALOPT=""
  if "$LOCAL"
  then
    LOCALOPT="--local"
  fi

  scp $SSHOPTS "$0" "$TARGET":setup.sh
  exec ssh $SSHOPTS "$TARGET" -- ./setup.sh "$LOCALOPT"
}

minimal() {
  stderr "Performing minimal setup"
  local TILDEDIR
  TILDEDIR="$HOME/r/github.com/cceckman/Tilde"
  mkdir -p "$(dirname "$TILDEDIR")"

  if ! test -d "$TILDEDIR"
  then
    stderr "Tilde not found; cloning..."
    sudo -n apt-get -y install git || {
      stderr "Could not achieve noninteractive sudo mode to install git"
    }
    git clone --depth=1 \
      https://github.com/cceckman/Tilde \
      "$HOME"/r/github.com/cceckman/Tilde
  else
    stderr "Tilde already cloned; not overwriting"
  fi
  "$HOME"/r/github.com/cceckman/Tilde/minimal-setup.sh
  stderr "Completed minimal setup"
}

local_setup() {
  stderr "Beginning local setup"
  # Assume minimal is already done...
  "$HOME"/r/github.com/cceckman/Tilde/local-setup.sh
  stderr "Completed local setup"
}

main() {
  parse_args "$@"
  if test -n "$TARGET"
  then
    stderr "Performing setup on remote host $TARGET"
    bounce
    exit $?
  fi

  minimal
  if "$LOCAL"
  then
    local_setup
  fi
}

main "$@"
