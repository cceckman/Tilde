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
       else
         # echo >&2 "$x doesn't exist"
         true
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
/usr/local/bin
/usr/local/google-cloud-sdk/bin
$HOME/.nix-profile/bin
/opt/nvim-linux64/bin
$HOME/.fly/bin/
$HOME/.ghcup/bin
$HOME/.cabal/bin
ADDPATHS

export PATH

# Likewise, for LD_LIBRARY_PATH.
while read x
do
  case ":$LD_LIBRARY_PATH:" in
    *":$x:"*) ;;
    "::") if test -d "$x";
       then
         LD_LIBRARY_PATH="$x"
       else
         echo >&2 "$x doesn't exist"
       fi
       ;;
    *":"*) if test -d "$x";
       then
         LD_LIBRARY_PATH="$x:$LD_LIBRARY_PATH"
       else
         echo >&2 "$x doesn't exist"
       fi
       ;;
  esac
done <<ADDPATHS
/usr/local/lib
ADDPATHS

export LD_LIBRARY_PATH

