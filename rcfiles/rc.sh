#!/bin/sh
# vim: ft=sh

# if test -f $HOME/themes/terminal.inc.sh
# then
#   . $HOME/themes/terminal.inc.sh
# fi

helpless() {
  "$@" --help 2>&1 | less
}

. $HOME/rcfiles/path.sh
. $HOME/rcfiles/repo.sh

ws () {
  r $1 && attach $(echo "$1" | tr ':.' '-')
}

ssh() {
  /usr/bin/ssh "$@"
  title
}
