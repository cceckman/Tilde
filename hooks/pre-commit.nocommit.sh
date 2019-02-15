#!/bin/sh
# Detect if a modified file has "DO NOT COMMIT" (or mispellings thereof).
#
# Based on pre-commit.gofmt.sh, which is:
# Copyright 2012 The Go Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# git nocommit pre-commit hook
#
# This script does not handle file names that contain spaces.
# This script dete

difffiles=$(git diff --cached --name-only --diff-filter=ACM)
[ -z "$difffiles" ] && exit 0

diff="$(grep -PH 'DO NOT (CO[MI]+T|SU[BMI]+T)' $difffiles 2>&1)"
[ -z "$diff" ] && exit 0

echo >&2 "Some files indicate they should not be committed: "
echo >&2 "$diff"

exit 1
