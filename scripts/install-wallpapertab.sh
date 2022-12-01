#!/bin/sh
#
# install-wallpapertab.sh
# Install crontab for wallpaper rotation.


key='wallpaper-rotate'
f=$(mktemp)
echo "*/5 * * * *  DISPLAY=:0.0 feh --bg-fill \"\$(find ~/secrets/wallpaper/* | shuf -n1)\" # $key " >$f
crontab -l \
  | grep -v "$key" \
  | cat - $f \
  | crontab -

