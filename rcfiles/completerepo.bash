#! /bin/bash
#
# completerepo.bash
# Bash completion for the r() function in repo.sh

. $HOME/rcfiles/repo.sh

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
