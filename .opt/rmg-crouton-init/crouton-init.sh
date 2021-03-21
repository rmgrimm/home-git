#!/bin/bash

# Set this to run with ChromeOS-AutoStart
# URL: https://github.com/supechicken/ChromeOS-AutoStart
# Command: sudo /usr/local/bin/enter-chroot -n <chroot-name> exec ~/.opt/rmg-crouton-init/crouton-init.sh

# Start a common ssh-agent instance
if command -v ssh-agent >/dev/null
then
  eval $(ssh-agent -s)
fi

# Start up the primary sommelier instance, and give it time to start
,run-sommelier.sh
sleep 30

# Start lxterminal
if command -v lxterminal >/dev/null
then
  ,run-sommelier.sh lxterminal
elif command -v xterm >/dev/null
  ,run-sommelier.sh xterm
fi

