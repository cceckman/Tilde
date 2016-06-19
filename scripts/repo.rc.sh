#!/bin/bash
# Define a 'repo' function that gets the current repository / branch.
repo() {
  GIT="$(git branch --no-color 2>/dev/null | grep '[*]' | grep -o '[^* ]*')"
  if [ $? -eq 0 ]
  then
    echo "$GIT:"
  fi
}
