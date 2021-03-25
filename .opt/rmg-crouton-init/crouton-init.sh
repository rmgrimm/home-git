#!/bin/bash

# Set this to run with ChromeOS-AutoStart
# URL: https://github.com/supechicken/ChromeOS-AutoStart
# Command: sudo /usr/local/bin/enter-chroot -n <chroot-name> exec /home/robert/.opt/rmg-crouton-init/crouton-init.sh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_RUNTIME_DIR="/var/run/chrome"
export XDG_DATA_DIRS="$HOME/.local/share:/usr/local/share:/usr/share""

# Start a common ssh-agent instance
if command -v ssh-agent >/dev/null
then
  eval $(ssh-agent -s)
fi

# Start up the primary sommelier instance, and give it time to start
,run-sommelier.sh
sleep 30

# Start dbus-daemon through dbus-launch and tie it to the X11 server of sommelier
if command -v dbus-launch >/dev/null
then
  export XDG_DATA_DIRS="$HOME/.local/share:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share""
  export DISPLAY=:0
  eval $(dbus-launch --sh-syntax --exit-with-x11)
fi

# Start lxterminal
if command -v lxterminal >/dev/null
then
  ,run-sommelier.sh lxterminal
elif command -v xterm >/dev/null
then
  ,run-sommelier.sh xterm
fi
