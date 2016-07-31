#!/bin/sh

if ! type __rmg_d_run >/dev/null 2>&1 ; then
  . "$HOME/.local/bin/docker/.docker-init.sh"
fi

# If running interactively, message the user that docker will run X programs
case $- in
  *i*)
    if [ -n "$Color_Off" ]; then
      echo -e "Dockerized "$BPurple"X11 applications"$Color_Off"; some commands overridden"
    else
      echo "Dockerized X11 applications; some commands overridden"
    fi
    ;;
esac
