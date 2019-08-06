#!/bin/bash
# Detect if a modified file has "DO NOT COMMIT" (or mispellings thereof).
#
# Based on pre-commit.gofmt.sh, which is:
# Copyright 2012 The Go Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# git nocommit pre-commit hook

MATCH='DO NOT (CO[MI]+T|SU[BMI]+T)'

OLDIFS="$IFS"
IFS=$'\n'
OK="true"
for file in $(git diff --cached --name-only --diff-filter=ACM)
do
  if grep -q -P "$MATCH" "$file"
  then
    echo >&2 "$file indicates it should not be committed:"
    grep -Pn "$MATCH" "$file" >&2
    OK="false"
  fi
done
IFS="$OLDIFS"

if ! "$OK"
then
  exit 1
fi

exit 1
