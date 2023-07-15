#!/bin/sh

set -eu

stderr() {
  echo >&2 "$@"
}

check_user() {
  if test "$USER" != "cceckman"
  then
    stderr "\$USER is not cceckman; refusing to perform local setup."
    stderr "(Assuming this is a shared machine.)"
    exit 1
  fi
  stderr "\$USER is cceckman, proceeding."
}

check_sudo() {
  stderr "Checking / obtaining sudo permissions..."
  if ! sudo echo >&2 "Successfully authenticated!"
  then
    stderr "Could not perform sudo authentication."
    stderr "Do you have permission to install onto this host?"
    exit 1
  fi
  stderr "Can use sudo."
}

main() {
  check_user
  check_sudo

  set +x
  sudo -n apt-get install -y tmux zsh
  ZSH="$(cat /etc/shells | grep zsh | head -1)"
  sudo -n usermod --shell "$ZSH" "$USER"
  set -x

  TILDE="$(dirname "$(readlink -f "$0")")"
  ln -sf "$TILDE"/tmux.conf "$HOME"/.tmux.conf
  ln -sf "$TILDE"/rcfiles/ "$HOME"/rcfiles
  ln -sf "$HOME"/rcfiles/portablerc.sh "$HOME"/.zshrc
}

main "$@"
