# Not actually POSIX; but bash/zsh compatible.
# To be sourced rather than executed.

# Utility functions for dealing with repositories.
# Include in a startup file.

# See also update-repos.

# git root.
gr() {
  if base="$(git rev-parse --show-toplevel)" && [ "$base" != "" ]
  then
    echo "$base"
    return 0
  elif pwd | grep -q '[.]git'
  then
    echo "$(pwd | grep -Pho '.*(?=/.git)')"
    return 0
  else
    echo 1>&2 "Not under Git?"
    return 1
  fi
}

# Define a 'repo' function that gets the current repository / branch.
_repo() {
  if which git 2>&1 >/dev/null
  then
    GITBASE="$(basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null)" || return
    GITBRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" || return
  fi

  if test "$GITBASE" != "" && test "$GITBRANCH" != ""
  then
    echo "${GITBASE}:${GITBRANCH}…"
  fi
}

# go to git root, or push to git root
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
  # r/<host>/<user>/<repo>
  find $HOME/r -maxdepth 3 -mindepth 3 \
    | xargs basename -a \
    | sort -u
}

r() {
  # List pulled repositories, with no arguments
  if [ "$#" -eq 0 ]
  then
    _lsrepos
    return
  fi

  # List my repositories on Github
  if test "$1" = "ls"
  then
    curl -s https://api.github.com/users/cceckman/repos | jq '.[] | .full_name' | sed 's/"//g'
    return
  fi

  # Normal:
  # cd to a repository by a short name.
  # If there are duplicates of that name, pick mine.
  if test -d $HOME/r/*/cceckman/$1
  then
    cd $HOME/r/*/cceckman/$1
    pwd
    return
  fi
  if test -d $HOME/go/src/*/cceckman/$1
  then
    cd $HOME/go/src/*/cceckman/$1
    pwd
    return
  fi

  local matches="$(echo $HOME/r/*/*/$1)"
  local n="$(echo $matches | wc -w)"
  if test "$n" -eq 1
  then
    cd $HOME/r/*/*/$1
    pwd
    return
  fi
  if test "$n" -gt 1
  then
    echo "Couldn't unambiguously identify ${1}: $matches"
    return 1
  fi

  local matches="$(echo $HOME/go/src/*/*/$1)"
  local n="$(echo $matches | wc -w)"
  if test "$n" -eq 1
  then
    cd $HOME/go/src/*/*/$1
    pwd
    return
  fi
  if test "$n" -gt 1
  then
    echo "Couldn't unambiguously identify ${1}: $matches"
    return 1
  fi

  echo "Couldn't find any repository ${1}!"
  return 1
}


