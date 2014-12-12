#!/bin/bash

# Drop sudo cache and ask again to confirm sudo
sudo -K
if ! sudo -v; then
  echo "sudo failed; aborting."
  exit 1
fi

# Use aptitude because apt-get doesn't store which packages are explicitly
# installed.
if ! which aptitude; then
  sudo apt-get install -y aptitude
fi

# Add PPAs
sudo add-apt-repository -y ppa:jtaylor/keepass
sudo add-apt-repository -y ppa:dlech/keepass2-plugins

sudo aptitude update

# Install APT packages
sudo aptitude install -y \
    apt-file             `: to find where files come from` \
    emacs24 emacs24-el emacs24-common-non-dfsg \
    etckeeper            `: track changes to /etc` \
    git gitk \
    keepass2 \
    keepass2-plugin-application-indicator \
    keepass2-plugin-application-menu \
    keepass2-plugin-keepasshttp \
    lrzip \
    lynx-cur \
    mosh \
    openssh-server \
    p7zip-full p7zip-rar \
    tmux \
    tree                 `: when ls is simply not enough` \
    unison \
    zile \
    \
    `: for Skype` \
    libqt4-dbus libqtwebkit4
