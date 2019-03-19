#!/bin/bash
# Bash-only initialization / aliases.

. $HOME/rcfiles/rc.sh

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Typing is hard; use shell autocorrect, when available
if bash -o dirspell >/dev/null 2>&1
then
  shopt -s cdspell dirspell
fi

echo "using bash shell..."
