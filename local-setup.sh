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
    if test "$(git rev-parse --is-shallow-repository)" = true
    then
      stderr "Unshallowing Tilde"
      git fetch --unshallow
    fi
    git submodule update --init --recursive
    git remote prune origin
    # Unshallow, then promote to SSH;
    # We likely haven't minted or enrolled a pubkey for Github
    if git remote get-url origin | grep -q 'http'
    then
      stderr "Upgrading Tilde to SSH"
      git remote set-url origin git@github.com:cceckman/Tilde.git
    fi
  )
}

ssh_config() {
  (
    set +x
    cd

    if ! test -f .ssh/config
    then
      cat <<EOF >.ssh/config
Host *
  PasswordAuthentication no
  # Only use identity files, not any identity loaded in ssh-agent
  IdentitiesOnly yes
  ControlPath ~/.ssh/control-%h-%p-%r
  ControlMaster=auto
  ControlPersist=10

EOF
    fi

    if ! test -f .ssh/id_github.pub
    then
      stderr "Generating an SSH keypair for github.com"
      ssh-keygen -t ed25519 -C cceckman@"$(hostname)" -f .ssh/id_github
    fi
    if ! grep "^Host github.com" .ssh/config
    then
      stderr "Adding GH stanza to .ssh/config"
      cat <<EOF >>.ssh/config
Host github.com
  PasswordAuthentication no
  IdentitiesOnly yes
  IdentityFile %d/.ssh/id_github

EOF
    fi
  )
}

upgrade_links() {
  (
    stderr "Updating homedir links"
    ln -sf "$TILDE"/.config/ "$HOME"
    ln -sf "$TILDE"/.gitignore_global "$HOME"
    ln -sf "$TILDE"/.gitconfig "$HOME"
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

install_go() {
  VERSION="go1.21.4"
  if type go 2>&1 >/dev/null
  then
    stderr "Found Go:"
    type go

    if test "$(go version | cut -d' ' -f3)" = "$VERSION"
    then
      stderr "$VERSION installed"
      return 0
    fi
  fi

  stderr "Installing Go $VERSION"
  GOFILE="$(mktemp -d)/go.tar.gz"
  curl --fail -Lo "$GOFILE" \
    https://go.dev/dl/"$VERSION".linux-amd64.tar.gz
  sudo rm -rf /usr/local/go && \
    sudo tar -C /usr/local -xzf "$GOFILE"
}

install_toolchains() {
  stderr "Installing toolchains"
  (
    if type cargo 2>&1 >/dev/null
    then
      stderr "Found Cargo:"
      type cargo
    else
      stderr "Installing Rust via Rustup"
      curl https://sh.rustup.rs -sSf | sh -s -- \
        --no-modify-path \
        -y \
        --component rust-analyzer \
        --target aarch64-unknown-linux-gnu \
        --target x86_64-unknown-linux-gnu
    fi
  )
  ( install_go )
  (
    if type bazel 2>&1 >/dev/null
    then
      stderr "Found bazel:"
      type bazel
    else
      stderr "Installing bazelisk (as bazel)"
      mkdir -p ~/.local/bin
      curl --fail -Lo ~/.local/bin/bazel \
        https://github.com/bazelbuild/bazelisk/releases/download/v1.18.0/bazelisk-linux-amd64
      chmod +x ~/.local/bin/bazel
    fi
  )
  sudo apt-get -y install clang llvm python3 lldb
  # TODO: sccache?
  # https://github.com/mozilla/sccache/blob/main/docs/DistributedQuickstart.md
  . "$HOME"/rcfiles/path.sh
}

install_gcloud() {
  # gcloud stanza: https://cloud.google.com/sdk/docs/install#deb
  if ! test -f /usr/share/keyrings/cloud.google.gpg
  then
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
      | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
  fi
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
  # We have to --no-install-recommends because it wants to install
  # app-engine-python, which still requires python2.7 apparently? Wild.
  sudo apt-get update && sudo apt-get install google-cloud-cli
  # This doesn't work - requires python2.7 (!!)
  # Filed b/312491174 for this.
  # sudo apt-get install google-cloud-cli-app-engine-go
}

install_tools() {
  # Various tools I like...
  cargo install git-branchless
  sudo apt-get -y install gh file inotify-tools

  install_gcloud
}

install_theme() {
  # Prerequisite for retheme script
  sudo apt-get -y install jq
  "$HOME"/scripts/retheme selenized dark
}

main() {
  upgrade_tilde
  upgrade_links
  install_toolchains
  install_tools
  ssh_config
  install_theme
}

main
