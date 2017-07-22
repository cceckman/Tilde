#!/bin/sh
# Not actually POSIX; but bash/zsh compatible

# Utility functions for dealing with repositories.
# Include in an startup file.

# See also update-repos.

# Define a 'repo' function that gets the current repository / branch.
repo() {
  GIT="$(git branch --no-color 2>/dev/null | egrep '[*]' | egrep -o '[^* ]+')"
  a="$?"
  root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if test $? -eq 0 && test $a -eq 0
  then
    echo "$(basename $root):$GIT…"
  fi
}

# git root; or git-root push
gr() {
  if ! base="$(git rev-parse --show-toplevel)"
  then
    echo "Not under Git?"
    return 1
  fi
  echo "$base"
}

ggr() {
  if ! base=$(gr)
  then
    return 1
  fi
  if test "$1" = "p"
  then
    pushd "$base"
  else
    cd "$base"
    pwd
  fi
}

_lsrepos() {
  echo "$(find $HOME/go/src/github.com -maxdepth 2 -mindepth 2 | xargs basename -a | sort | uniq)"
}

r() {
  # List pulled repositories, with no arguments
  if [ "$#" -eq 0 ]
  then
    _lsrepos
    return
  fi

  # List my repositories on Github
  if test "$1" = "r"
  then
    curl -s https://api.github.com/users/cceckman/repos | jq '.[] | .full_name' | sed 's/"//g'
    return
  fi

  # Normal:
  # cd to a repository by a short name.
  if sh -c "test -d $HOME/go/src/github.com/*/$1"
  then
    cd $HOME/go/src/github.com/*/$1
    pwd
  else
    echo "Couldn't identify repository $1"
    return 1
  fi
}


