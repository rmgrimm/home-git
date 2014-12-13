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

# And PlayOnLinux repo
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
sudo wget "http://deb.playonlinux.com/playonlinux_$(lsb_release -c -s).list" \
    -O/etc/apt/sources.list.d/playonlinux.list

# Add Dropbox repo
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
sudo add-apt-repository -y \
    "deb http://linux.dropbox.com/ubuntu/ $(lsb_release -c -s) main"

sudo aptitude update

# Install APT packages
sudo aptitude install -y \
    apt-file             `: to find where files come from` \
    dropbox \
    emacs24 emacs24-el emacs24-common-non-dfsg \
    etckeeper            `: track changes to /etc` \
    git gitk \
    keepass2 \
    keepass2-plugin-application-indicator \
    keepass2-plugin-application-menu \
    keepass2-plugin-keepasshttp \
    lrzip \
    lynx-cur \
    mesa-utils \
    mono-complete \
    mosh \
    openssh-server \
    p7zip-full p7zip-rar \
    playonlinux \
    tmux \
    tree                 `: when ls is simply not enough` \
    unison \
    zile \
    \
    `: for Dropbox` \
    python-gpgme \
    \
    `: for Skype` \
    libqt4-dbus libqtwebkit4 \
    \
    `: so Language Support dialog doesn't complain` \
    mythes-en-au libreoffice-l10n-en-za libreoffice-help-en-gb \
    thunderbird-locale-en-gb libreoffice-l10n-en-gb hunspell-en-ca

# Initialize apt-file's cache
if ! ls /var/cache/apt/apt-file | grep -q .; then
  sudo apt-file update
fi

# Add TrayTOTP to Keepass2
sudo wget "http://sourceforge.net/projects/traytotp-kp2/files/Tray%20TOTP%20v.%202.0.0.5/TrayTotp.plgx/download" \
    -O/usr/lib/keepass2/plugins/TrayTOTP.plgx

# Purge some nonsense
sudo aptitude purge -f \
    unity-webapps-common

# Remove some bad settings
gsettings set com.canonical.Unity.Lenses remote-content-search 'none'
gsettings set com.canonical.unity.webapps integration-allowed false
gsettings set com.canonical.unity.webapps preauthorized-domains []

# Otherwise set up preferred look of desktop
gsettings set com.canonical.indicator.bluetooth visible false
gsettings set com.canonical.indicator.datetime locations [ \
    'America/Chicago Omaha', \
    'UTC UTC', \
    'Asia/Shanghai Hangzhou']
gsettings set com.canonical.indicator.datetime show-date true
gsettings set com.canonical.indicator.datetime show-day true
gsettings set com.canonical.indicator.datetime show-locations true
gsettings set com.canonical.indicator.datetime timezone-name \
    'America/Chicago Omaha'
gsettings set com.canonical.indicator.power show-percentage true
gsettings set com.canonical.indicator.power show-time true
gsettings set com.canonical.unity-greeter play-ready-sound false
gsettings set com.canonical.Unity.Launcher favorites [ \
    'application://nautilus.desktop', \
    'application://emacs24.desktop', \
    'application://firefox.desktop', \
    'application://gnome-system-monitor.desktop', \
    'application://PlayOnLinux.desktop', \
    'unity://running-apps', \
    'unity://expo-icon', \
    'unity://desktop-icon', \
    'unity://devices']
