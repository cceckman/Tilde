#!/bin/sh

set -eu

set -eu

stderr() {
  echo >&2 "$@"
}

TILDE="$HOME"/r/github.com/cceckman/Tilde

upgrade_tilde() {
  (
    set +x
    cd "$TILDE"
    git remote set-url origin git@github.com:cceckman/Tilde.git
    git fetch --unshallow
    git submodule update --init --recursive
    git remote prune origin
  )
}

upgrade_links() {
  (
    ln -sf "$TILDE"/.config "$HOME"/.config
    ln -sf "$TILDE"/.gitignore_global "$HOME"/.gitignore_global
    ln -sf "$TILDE"/.vim "$HOME"/.vim
    ln -sf "$TILDE"/.vimrc "$HOME"/.vimrc
    ln -sf "$TILDE"/.zsh "$HOME"/.zsh
    ln -sf "$TILDE"/rcfiles "$HOME"/rcfiles
    ln -sf "$TILDE"/scripts "$HOME"/scripts
    ln -sf "$TILDE"/themes "$HOME"/themes

    mkdir -p .vscode/extensions/
    ln -sf \
      "$TILDE"/.vscode/extensions/selenized \
      "$HOME"/.vscode/extensions/selenized
  )
}

main() {
  upgrade_tilde
  upgrade_links
}
