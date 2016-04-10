#!/bin/bash
SCRIPTS="hilightwin.pl trackbar.pl adv_windowlist.pl"
for script in $SCRIPTS
do
  curl -Lo $script \
    https://raw.githubusercontent.com/irssi/scripts.irssi.org/gh-pages/scripts/${script} && \
  ln -s ${script} autorun/${script}
done
