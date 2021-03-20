#!/bin/bash

# Based loosely upon concepts from
# https://github.com/dnschneid/crouton/wiki/Sommelier-%28A-more-native-alternative-to-xiwi%29

# Set this to run with ChromeOS-AutoStart
# URL: https://github.com/supechicken/ChromeOS-AutoStart
# Command: sudo /usr/local/bin/enter-chroot -n <chroot-name> exec ,run-sommelier.sh xterm


export GDK_BACKEND=x11
export CLUTTER_BACKEND=wayland
export XDG_RUNTIME_DIR=/var/run/chrome
export WAYLAND_DISPLAY=wayland-0
export DISPLAY=:0
export SCALE=1

if [ -r "/usr/local/etc/sommelierrc" ]
then
  SOMMELIERRC=/usr/local/etc/sommelierrc
elif [ -r "/etc/sommelierrc" ]
then
  SOMMELIERRC=/etc/sommelierrc
else
  SOMMELIERRC="$HOME"/.sommelierrc
fi

SOMM_PID=$(pidof sommelier 2>/dev/null)
if [ -z "$SOMM_PID" ]
then
  sommelier -X \
    --x-display="$DISPLAY" \
    --display="$WAYLAND_DISPLAY" \
    --scale="$SCALE" \
    --glamor \
    --drm-device=/dev/dri/renderD128 \
    --virtwl-device=/dev/null \
    --shm-driver=noop \
    --data-driver=noop \
    --peer-cmd-prefix=/lib64/ld-linux-x86-64.so.2 \
    --xwayland-path=/usr/bin/Xwayland \
    --no-exit-with-child \
    /bin/sh -c ". $SOMMELIERRC" &

  sleep 3
  SOMM_PID=$(pidof sommelier 2>/dev/null)
fi

if [ -z "$SOMM_PID" ]
then
  echo "sommelier failed to start..."
  exit 1
else
  echo "sommelier (PID $SOMM_PID) is running"
fi

if [ "$1" -ne "" ]
then
  exec sommelier "$@"
fi