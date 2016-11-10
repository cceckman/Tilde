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
xrdb "-DCUSTOM_DPI=$MY_DPI" -merge $HOME/.Xresources

xscreensaver -no-splash &

exec i3
