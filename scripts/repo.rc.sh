# Utility functions for dealing with repositories.
# Include in an startup file.

# See also update-repos.

# Define a 'repo' function that gets the current repository / branch.
repo() {
  GIT="$(git branch --no-color 2>/dev/null | egrep '[*]' | egrep -o '[^* ]+')"
  if [ $? -eq 0 ]
  then
    echo "$GIT:"
  fi
}


_lsrepos() {
  echo "$(find $HOME/r -maxdepth 2 -mindepth 2 | xargs basename -a | sort | uniq)"
}

r() {
  # List pulled repositories, with no arguments
  if [ "$#" -eq 0 ]
  then
    _lsrepos
    return
  fi

  # List my repositories on Github
  if [ "$1" == "r" ]
  then
    curl -s https://api.github.com/users/cceckman/repos | jq '.[] | .full_name' | sed 's/"//g' 
    return
  fi

  # Normal:
  # cd to a repository by a short name.
  if [ -d $HOME/r/*/$1 ]
  then
    cd $HOME/r/*/$1
    pwd
  else
    echo "Couldn't identify repository $1"
  fi
}


_CompleteR() {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  # Yeah, this is more verbose than it needs to be because I copy-pasted from
  # the Internet. I'm okay with that.
  case "$cur" in
    *)
      COMPREPLY=( $( compgen -W "$(_lsrepos)" -- $cur ) )
      ;;
  esac
  return 0
}
complete -F _CompleteR r
