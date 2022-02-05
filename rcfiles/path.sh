#! /bin/sh
#
# Reentrant addition of items to $PATH:
# Doesn't add if the item is already present.

# Use $HOME/go for GOPATH.
GOPATH="${GOPATH:-$HOME/go}"
if ! echo "$GOPATH" | grep -q "$HOME/go"
then
  if test -z "$GOPATH"
  then
    GOPATH="$HOME/go"
  else
    GOPATH="$GOPATH:$HOME/go"
  fi
fi
export GOPATH

while read x
do
  case ":$PATH:" in
    *":$x:"*) ;;
    *) if test -d "$x";
       then
         PATH="$x:$PATH"
       fi
       ;;
  esac
done <<ADDPATHS
$HOME/.cargo/bin
$HOME/.local/bin
$HOME/bin
$GOPATH/bin
$HOME/scripts
/usr/local/go/bin
/usr/local/google-cloud-sdk/bin
$HOME/.nix-profile/bin
ADDPATHS

export PATH

