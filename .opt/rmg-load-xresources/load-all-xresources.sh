#!/bin/bash

if command -v xrdb >/dev/null
then
  for i in $HOME/.config/Xresources/*.Xresources $HOME/.Xresources
  do
    if [ -r "$i" ]
    then
      xrdb -merge "$i"
    fi
  done
fi
