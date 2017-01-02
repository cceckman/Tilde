#!/bin/sh

# Should be a better conditional;
# check /proc/cpuinfo for 'hypervisor'
if [ -x /usr/bin/VBoxClient-all ]
then
  /usr/bin/VBoxClient-all
fi

MY_DPI=$(xdpyinfo \
  | grep dots \
  | grep -Po '([0-9]{2,3})x\1' \
  | grep -Po '^[^x]*' )
MY_DIMS=$(xdpyinfo \
  | grep dimension \
  | grep -Po '[0-9]+x[0-9]+' \
  | tail -1 | sed 's/x/ /g' )

for dim in $MY_DIMS
do
  if test $dim -gt 1000
  then
    MY_DPI=$(echo "$MY_DPI * 4 / 3" | bc)
    break
  fi
done

xrdb "-DCUSTOM_DPI=$MY_DPI" -merge $HOME/.Xresources

xscreensaver -no-splash &

exec i3
