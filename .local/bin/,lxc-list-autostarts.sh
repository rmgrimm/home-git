#!/bin/bash

# Based on https://www.cyberciti.biz/faq/how-to-auto-start-lxd-containers-at-boot-time-in-linux/#more-145952

echo 'The current values of each vm boot parameters:'
for c in $(lxc list --columns=n | grep -F '| ' | sed -e 's/| \(.*\) |/\1/' | grep -v -F 'NAME')
do
   echo "*** VM: $c ***"
   for v in boot.autostart boot.autostart.priority boot.autostart.delay 
   do
      echo "Key: $v => $(lxc config get $c $v)"
   done
      echo ""
done

