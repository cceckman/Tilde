#!/bin/sh

# Keep this early, so subsequent includes can access COLOR
if [ -x $HOME/scripts/syscolor ]
then
  export SYSCOLOR="$($HOME/scripts/syscolor)"
else
  export SYSCOLOR="red"
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$SYSCOLOR"
