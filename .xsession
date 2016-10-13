if [ -x /usr/bin/VBoxClient-all ]
then
  /usr/bin/VBoxClient-all
fi
xscreensaver &
xss-lock -- xscreensaver-command -lock &
exec i3
