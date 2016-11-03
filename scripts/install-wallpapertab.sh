#! /bin/bash
#
# install-wallpapertab.sh
# Install crontab for wallpaper rotation.


key='wallpaper-rotate'
crontab -l \
  | grep -v "$key" \
  | cat - \
    <(echo "*/5 * * * *  DISPLAY=:0.0 feh --bg-fill \"\$(find ~/secrets/wallpaper/* | shuf -n1)\" # $key ") \
  | crontab -

