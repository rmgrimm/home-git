#!/bin/bash

for i in $HOME/.config/Xresources/*.Xresources $HOME/.Xresources
do
  if [ -r "$i" ]
  then
    /usr/bin/xrdb -merge "$i"
  fi
done
