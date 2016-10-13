#!/bin/sh

# Should be a better conditional;
# check /proc/cpuinfo for 'hypervisor'
if [ -x /usr/bin/VBoxClient-all ]
then
  /usr/bin/VBoxClient-all
fi

xscreensaver -no-splash &
exec i3
