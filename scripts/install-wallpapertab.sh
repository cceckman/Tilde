#! /bin/bash
#
# install-wallpapertab.sh
# Install crontab for wallpaper rotation.


key='wallpaper-rotate'
export CRONTAB_NOHEADER='N'
crontab -l \
  | grep -v "$key" \
  | cat - \
    <(echo "* * * * *  DISPLAY=:0.0 feh --bg-fill \"\$(find ~/secrets/.wallpaper/ | shuf -n1) # $key \"") \
  | crontab -

