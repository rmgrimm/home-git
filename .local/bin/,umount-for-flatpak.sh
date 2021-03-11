#!/bin/bash

set -e

# Unmount lxcfs items that get mounted over /proc
# These interfere with bwrap when attempting to run flatpak
# More info at https://www.reddit.com/r/Crostini/comments/gfi45d/flatpak_broken_on_m83beta_830410342/fsqnc93/?context=3
# And https://bugs.chromium.org/p/chromium/issues/detail?id=1087937

PATHS_TO_UMOUNT=$(mount | grep -F lxcfs | cut -d' ' -f3 | tr '\n' ' ')

if [ -n "$PATHS_TO_UMOUNT" ]
then
  echo -n "Unmounting: $PATHS_TO_UMOUNT..."
  sudo umount $PATHS_TO_UMOUNT
  echo "done."
else
  echo "No paths to umount..."
fi
