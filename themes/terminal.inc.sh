# Terminal retheming: from https://gist.github.com/johnbender/5018685
cset() {
  ANSI=$1
  RGB=$2
  printf "\x1b]4;$ANSI;rgb:${RGB}\a"
}

theme_terminal() {
  if test "$TERM" = "alacritty"
  then
    # Should already be themed.
    return 0
  fi

  cset 0 "18/49/56"
  cset 8 "2d/5b/69"
  cset 1 "fa/57/50"
  cset 9 "ff/66/5c"
  cset 2 "75/b9/38"
  cset 10 "84/c7/47"
  cset 3 "db/b3/2d"
  cset 11 "eb/c1/3d"
  cset 4 "46/95/f7"
  cset 12 "58/a3/ff"
  cset 5 "f2/75/be"
  cset 13 "ff/84/cd"
  cset 6 "41/c7/b9"
  cset 14 "53/d6/c7"
  cset 7 "72/89/8f"
  cset 15 "ca/d8/d9"
  # FG and BG per escape codes at
  # https://chromium.googlesource.com/apps/libapps/+/a5fb83c190aa9d74f4a9bca233dac6be2664e9e9/hterm/doc/ControlSequences.md#OSC
  printf "\x1b]10;#adbcbc\a"
  printf "\x1b]11;#103c48\a"
}
theme_terminal
