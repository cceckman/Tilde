#! /bin/sh
#
# Format a file containing a Markdown table so the columns are aligned
OUT="$(mktemp)"
IN="$1"
column -o'|' -s'|' -t "$IN" | tee "$OUT"
cp "$OUT" "$IN"
