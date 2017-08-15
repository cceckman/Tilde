#!/usr/bin/zsh
# Completion functions for zsh.

_r() {
  _alternative "args:custom args:_lsrepos"
}

compdef _lsrepos r
