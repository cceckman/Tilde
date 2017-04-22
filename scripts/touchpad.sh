#! /bin/sh
# From https://wiki.archlinux.org/index.php/Touchpad_Synaptics
# Toggle touchpad with printscreen
if which synclient >/dev/null && [ -x $(which synclient) ]
then
  synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')
fi
