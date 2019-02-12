#! /bin/sh
#
# Utilities for hooks.

CANCEL=0

WARNING() {
  echo >&2 -n "\e[33mWARNING:\e[0m "
  echo >&2 "$@"
}

ERROR() {
  echo >&2 -n "\e[31mERROR:\e[0m   "
  echo >&2 "$@"
  CANCEL=1
}

OK() {
  echo >&2 -n "\e[32mOK:\e[0m      "
  echo >&2 "$@"
}

INFO() {
  echo >&2 -n "\e[34mINFO:\e[0m    "
  echo >&2 "$@"
}
