#!/bin/bash

if [ -z "$DISPLAY" ]; then
    echo "This script is intended to be run from a desktop terminal."
    exit 1
fi

# Drop sudo cache and ask again to confirm sudo
sudo -K
if ! sudo -v; then
    echo "sudo failed; aborting."
    exit 1
fi

# Use aptitude because apt-get doesn't store which packages are explicitly
# installed.
#if ! which aptitude >/dev/null; then
#    sudo apt-get install -y aptitude
#fi

COMMON_SCRIPT_PATH="$(dirname $0)/common"

"$COMMON_SCRIPT_PATH/setup-ubuntu-desktop-packages.sh" repos || exit 1
"$COMMON_SCRIPT_PATH/setup-ubuntu-terminal-packages.sh" repos || exit 1

# Update package information
sudo apt update

# Upgrade everything
sudo apt full-upgrade -y

"$COMMON_SCRIPT_PATH/setup-ubuntu-desktop-packages.sh" packages || exit 1
"$COMMON_SCRIPT_PATH/setup-ubuntu-terminal-packages.sh" packages || exit 1

"$COMMON_SCRIPT_PATH/setup-ubuntu-desktop-settings.sh" || exit 1

echo "Done!"
