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

init_ssh() {
  stderr "Seeding authorized_keys..."
  if ! test -f ~/.ssh/authorized_keys
  then
    stderr "No authorized_keys present; seeding with init key"
    (umask 0077; mkdir -p ~/.ssh; cp "$1" ~/.ssh/authorized_keys)
  fi
}

main() {
  check_user
  check_sudo

  set +x
  sudo -n apt-get install -y tmux zsh vim ripgrep moreutils
  ZSH="$(cat /etc/shells | grep zsh | head -1)"
  sudo -n usermod --shell "$ZSH" "$USER"
  set -x

  TILDE="$(dirname "$(readlink -f "$0")")"
  init_ssh "$TILDE"/id_init.pub
  ln -sf "$TILDE"/tmux.conf "$HOME"/.tmux.conf
  ln -sf "$TILDE"/rcfiles "$HOME"
  ln -sf "$HOME"/rcfiles/portablerc.sh "$HOME"/.zshrc
}

main "$@"
