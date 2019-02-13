#!/bin/sh
# Based on pre-commit.gofmt.sh, which is:
# Copyright 2012 The Go Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# git yamllint pre-commit hook
#
# This script does not handle file names that contain spaces.

yamlfiles=$(git diff --cached --name-only --diff-filter=ACM | grep '\.yaml$')
[ -z "$yamlfiles" ] && exit 0

output=$(yamllint $yamlfiles)
[ -z "$output" ] && exit 0

echo >&2 "yaml lint violation(s):\n$output"

exit 1
