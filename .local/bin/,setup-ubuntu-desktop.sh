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
if ! which aptitude >/dev/null; then
    sudo apt-get install -y aptitude
fi

# Add PPAs
sudo add-apt-repository -y ppa:jtaylor/keepass
sudo add-apt-repository -y ppa:dlech/keepass2-plugins

# Add Dropbox repo
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
echo "deb http://linux.dropbox.com/ubuntu $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/dropbox.list

# Add GetDeb repo
wget -q "http://archive.getdeb.net/getdeb-archive.key" -O- | \
    sudo apt-key add -
echo "deb http://archive.getdeb.net/ubuntu $(lsb_release -cs)-getdeb games" | \
    sudo tee /etc/apt/sources.list.d/getdeb.list

# Add PlayOnLinux repo
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
sudo wget "http://deb.playonlinux.com/playonlinux_$(lsb_release -cs).list" \
    -O/etc/apt/sources.list.d/playonlinux.list

# Add Skype repo
sudo add-apt-repository -y \
    "deb http://archive.canonical.com/ $(lsb_release -cs) partner"

# Add Steam repo
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B05498B7
echo "deb http://repo.steampowered.com/steam precise steam" | \
    sudo tee /etc/apt/sources.list.d/steam.list
echo "deb-src http://repo.steampowered.com/steam precise steam" | \
    sudo tee -a /etc/apt/sources.list.d/steam.list

# Update package information
sudo aptitude update

# Pre-accept EULAs (find more by debconf-show <package name>)
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula \
    select true | sudo debconf-set-selections

# Oops. Steam somehow assumes it's a decline; disabling for now
#echo steam steam/question select "I AGREE" | \
#    sudo debconf-set-selections

# Install APT packages
sudo aptitude install -y \
    apt-file             `: to find where files come from` \
    blueman              `: this is better than the ubuntu bluetooth mgr` \
    chromium-browser \
    dropbox \
    emacs24 emacs24-el emacs24-common-non-dfsg \
    etckeeper            `: track changes to /etc` \
    git gitk \
    keepass2 \
    keepass2-plugin-application-indicator \
    keepass2-plugin-application-menu \
    keepass2-plugin-keepasshttp \
    lrzip                `: high compression rate for large files` \
    lynx-cur \
    mesa-utils \
    mono-complete \
    mosh \
    mumble \
    openssh-server \
    p7zip-full p7zip-rar \
    playonlinux \
    python-gpgme         `: so Dropbox doesn\'t complain` \
    scummvm \
    skype \
    sqlite3 \
    steam \
    tmux \
    tree                 `: when ls is simply not enough` \
    ttf-mscorefonts-installer \
    unison \
    vlc \
    wine                 `: so PlayOnLinux won\'t complain` \
    xdotool              `: for KeePass autotype` \
    zile \
    \
    `: so Language Support dialog doesn\'t complain` \
    mythes-en-au libreoffice-l10n-en-za libreoffice-help-en-gb \
    thunderbird-locale-en-gb libreoffice-l10n-en-gb hunspell-en-ca

# Initialize apt-file's cache
if ! ls /var/cache/apt/apt-file | grep -q .; then
    sudo apt-file update
fi

# Additional plugins for Keepass2
sudo wget "http://sourceforge.net/projects/traytotp-kp2/files/Tray%20TOTP%20v.%202.0.0.5/TrayTotp.plgx/download" \
    -O/usr/lib/keepass2/plugins/TrayTOTP.plgx
sudo wget "http://sourceforge.net/projects/keepass-favicon/files/latest/download" \
    -O/usr/lib/keepass2/plugins/FaviconDownloader.plgx

# Don't hide any autostart items
sudo sed -i -e 's/NoDisplay=true/NoDisplay=false/' \
    /etc/xdg/autostart/*.desktop

# Don't autostart GNOME's half-implemented SSH agent
cp /etc/xdg/autostart/gnome-keyring-ssh.desktop "$HOME/.config/autostart"
echo "X-GNOME-Autostart-enabled=false" | \
    tee -a "$HOME/.config/autostart/gnome-keyring-ssh.desktop"

# No really, I don't want GNOME keyring agent.
mkdir -p "$HOME/.config/upstart"
echo manual | tee "$HOME/.config/upstart/gnome-keyring.override"

# Purge some nonsense
sudo aptitude purge -f \
    unity-webapps-common

# Remove some bad settings
gsettings set com.canonical.Unity.Lenses remote-content-search 'none'
gsettings set com.canonical.unity.webapps integration-allowed false
gsettings set com.canonical.unity.webapps preauthorized-domains "[]"

# Otherwise set up preferred look/feel of desktop
gsettings set com.canonical.indicator.bluetooth visible false
gsettings set com.canonical.indicator.datetime locations "[ \
    'America/Chicago Omaha', \
    'UTC UTC', \
    'Asia/Shanghai Hangzhou']"
gsettings set com.canonical.indicator.datetime show-date true
gsettings set com.canonical.indicator.datetime show-day true
gsettings set com.canonical.indicator.datetime show-locations true
gsettings set com.canonical.indicator.datetime timezone-name \
    'America/Chicago Omaha'
gsettings set com.canonical.indicator.power show-percentage true
gsettings set com.canonical.indicator.power show-time true
gsettings set com.canonical.unity-greeter play-ready-sound false
gsettings set com.canonical.Unity.Launcher favorites "[ \
    'application://emacs24.desktop', \
    'application://gnome-terminal.desktop', \
    'application://firefox.desktop', \
    'application://chromium-browser.desktop', \
    'application://android-studio.desktop', \
    'application://nautilus.desktop', \
    'application://gnome-system-monitor.desktop', \
    'application://mumble.desktop', \
    'application://skype.desktop', \
    'application://steam.desktop', \
    'application://PlayOnLinux.desktop', \
    'application://scummvm.desktop', \
    'unity://running-apps', \
    'unity://expo-icon', \
    'unity://desktop-icon', \
    'unity://devices']"
gsettings set org.gnome.desktop.input-sources sources "[ \
    ('xkb', 'us'), \
    ('ibus', 'pinyin')]"
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background primary-color '#000000000000'
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling automount-open false
gsettings set org.gnome.Vino icon-visibility 'always'
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[ \
    '<Super>space']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward \
    "['<Shift><Super>space']"
