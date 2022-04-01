#! /bin/sh
#
# Convert an Alacritty .yml file into a shell-include fragment.

if ! ( echo "$1" | grep -q -e '[a-z]\+-[a-z]\+.alacritty.yml' )
then
  echo >&2 "Takes one argument: <theme>-<variant>.alacritty.yml"
fi

if ! test -f "$1"
then
  echo >&2 "File $1 does not exist"
  exit 1
fi

THEME="$(echo "$1" | grep -o '^[a-z]\+')"
VARIANT="$(echo "$1" | grep -o -e '-[a-z]\+' | tr -d '-')"

INPUT="$1"
get_color() {
  yq "$1" "$INPUT" \
    | grep -o '[a-fA-F0-9]\{6\}'
}


mkdir -p "$THEME"
cat <<EOF | tee "${THEME}/${VARIANT}.inc.sh"
BACKGROUND=$(get_color .colors.primary.background)
FOREGROUND=$(get_color .colors.primary.foreground)

BLACK_NR=$(get_color .colors.normal.black)
RED_NR=$(get_color .colors.normal.red)
GREEN_NR=$(get_color .colors.normal.green)
YELLOW_NR=$(get_color .colors.normal.yellow)
BLUE_NR=$(get_color .colors.normal.blue)
MAGENTA_NR=$(get_color .colors.normal.magenta)
CYAN_NR=$(get_color .colors.normal.cyan)
WHITE_NR=$(get_color .colors.normal.white)

BLACK_BR=$(get_color .colors.bright.black)
RED_BR=$(get_color .colors.bright.red)
GREEN_BR=$(get_color .colors.bright.green)
YELLOW_BR=$(get_color .colors.bright.yellow)
BLUE_BR=$(get_color .colors.bright.blue)
MAGENTA_BR=$(get_color .colors.bright.magenta)
CYAN_BR=$(get_color .colors.bright.cyan)
WHITE_BR=$(get_color .colors.bright.white)
EOF
