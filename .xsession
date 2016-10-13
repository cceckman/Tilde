if [ -x /usr/bin/VBoxClient-all ]
then
  /usr/bin/VBoxClient-all
fi
xscreensaver -no-splash &
exec i3
