#!/bin/sh
# Based on pre-commit.gofmt.sh, which is:
# Copyright 2012 The Go Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# git rustfmt pre-commit hook
#
# This script does not handle file names that contain spaces.

rustfiles=$(git diff --cached --name-only --diff-filter=ACM | grep '\.rs$')
[ -z "$rustfiles" ] && exit 0

diff=$(rustfmt --check $rustfiles 2>&1)
[ -z "$diff" ] && exit 0

# Some files are not rustfmt'd. Print message and fail.
unformatted="$(echo "$diff" | grep -Pho "(?<=Diff in ).*(?=at line)" | sort -u)"

if ! test -z "$unformatted"
then
  echo >&2 "Rust files must be formatted with rustfmt. Please run:"
  for fn in $unformatted; do
    echo >&2 "  rustfmt $fn"
  done
else
  echo >&2 "Errors encountered in checking Rust formatting: "
  echo >&2 "$diff"
fi

exit 1
