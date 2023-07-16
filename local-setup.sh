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
    if git remote get-url origin | grep -q 'http'
    then
      stderr "Upgrading Tilde to SSH"
      git remote set-url origin git@github.com:cceckman/Tilde.git
    fi
    if test "$(git rev-parse --is-shallow-repository)" = true
    then
      stderr "Unshallowing Tilde"
      git fetch --unshallow
    fi
    git submodule update --init --recursive
    git remote prune origin
  )
}

upgrade_links() {
  (
    stderr "Updating homedir links"
    ln -sf "$TILDE"/.config/ "$HOME"
    ln -sf "$TILDE"/.gitignore_global "$HOME"
    ln -sf "$TILDE"/.vim "$HOME"
    ln -sf "$TILDE"/.vimrc "$HOME"
    ln -sf "$TILDE"/.zsh "$HOME"
    ln -sf "$TILDE"/scripts "$HOME"
    ln -sf "$TILDE"/themes "$HOME"

    mkdir -p "$HOME"/.vscode/extensions/
    ln -sf \
      "$TILDE"/.vscode/extensions/selenized \
      "$HOME"/.vscode/extensions/selenized
  )
}

install_toolchains() {
  (
    if ! type cargo 2>&1 >/dev/null
    then
      stderr "Installing Rust via Rustup"
      curl https://sh.rustup.rs -sSf | sh -s -- \
        --no-modify-path \
        -y \
        --component rust-analyzer \
        --target aarch64-unknown-linux-gnu \
        --target x86_64-unknown-linux-gnu
    fi
  )
  (
    if ! type go 2>&1 >/dev/null
    then
      stderr "Installing Go"
      GOFILE="$(mktemp -d)/go.tar.gz"
      curl --fail -Lo "$GOFILE" \
        https://go.dev/dl/go1.20.6.linux-amd64.tar.gz
      sudo rm -rf /usr/local/go
      sudo tar -C /usr/local -xzf "$GOFILE"
    fi
  )
  sudo apt-get -y install clang llvm python3 lldb
  # TODO: sccache:
  # https://github.com/mozilla/sccache/blob/main/docs/DistributedQuickstart.md
  . "$HOME"/rcfiles/path.sh
}

install_tools() {
  # Various tools I like...
  cargo install git-branchless
}

main() {
  upgrade_tilde
  upgrade_links
  install_toolchains
  install_tools
}

main
