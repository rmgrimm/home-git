#!/bin/bash

add_repos () {
    # Add KeePass related PPAs
    sudo add-apt-repository -y ppa:jtaylor/keepass || exit 1
    sudo add-apt-repository -y ppa:dlech/keepass2-plugins || exit 1

    # Add Dropbox repo
    sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E || exit 1
    echo "deb http://linux.dropbox.com/ubuntu $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/dropbox.list

    # Add GetDeb repo
    wget -q "http://archive.getdeb.net/getdeb-archive.key" -O- | \
        sudo apt-key add - || exit 1
    echo "deb http://archive.getdeb.net/ubuntu $(lsb_release -cs)-getdeb games" | \
        sudo tee /etc/apt/sources.list.d/getdeb.list

    # Add Mono repo (they build against wheezy only)
    sudo apt-key adv --keyserver keyserver.ubuntu.com \
        --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF || exit 1
    echo "deb http://download.mono-project.com/repo/debian wheezy main" | \
        sudo tee /etc/apt/sources.list.d/mono-xamarin.list

    # Add PlayOnLinux repo
    wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add - \
        || exit 1
    sudo wget "http://deb.playonlinux.com/playonlinux_$(lsb_release -cs).list" \
        -O/etc/apt/sources.list.d/playonlinux.list

    # Add Skype repo
    sudo add-apt-repository -y \
        "deb http://archive.canonical.com/ $(lsb_release -cs) partner" || exit 1

    # Add Steam repo
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B05498B7 || \
        exit 1
    echo "deb http://repo.steampowered.com/steam precise steam" | \
        sudo tee /etc/apt/sources.list.d/steam.list
    echo "deb-src http://repo.steampowered.com/steam precise steam" | \
        sudo tee -a /etc/apt/sources.list.d/steam.list

    exit 0
}

install_packages () {
    # Pre-accept EULAs (find more by debconf-show <package name>)
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula \
        select true | sudo debconf-set-selections || exit 1

    # Oops. Steam somehow assumes it's a decline; disabling for now
    #echo steam steam/question select "I AGREE" | \
    #    sudo debconf-set-selections || exit 1

    sudo aptitude install -y \
        blueman              `: this is better than the ubuntu bluetooth mgr` \
        chromium-browser \
        dropbox \
        git-gui gitk \
        keepass2 \
        keepass2-plugin-application-indicator \
        `: disabled for now -- keepass2-plugin-application-menu` \
        keepass2-plugin-keeagent \
        `: disabled for now -- keepass2-plugin-keepasshttp` \
        language-pack-en-base \
        language-pack-zh-hans-base \
        mesa-utils \
        mono-complete \
        mumble \
        playonlinux \
        python-gpgme         `: so Dropbox doesn\'t complain` \
        qemu-kvm \
        scummvm \
        skype \
        steam \
        ttf-mscorefonts-installer \
        vlc \
        wine                 `: so PlayOnLinux won\'t complain` \
        x11-utils            `: for xprop ` \
        xdotool              `: for KeePass autotype` \
        \
        `: so Language Support dialog doesn\'t complain` \
        mythes-en-au libreoffice-l10n-en-za libreoffice-help-en-gb \
        thunderbird-locale-en-gb libreoffice-l10n-en-gb hunspell-en-ca \
        \
        || exit 1

    # Initialize apt-file's cache
    if ! ls /var/cache/apt/apt-file | grep -q .; then
        sudo apt-file update || exit 1
    fi

    # Add current user to groups
    sudo adduser $(id -nu) kvm || exit 1

    # Additional plugins for Keepass2
    sudo wget "http://sourceforge.net/projects/keepass-favicon/files/latest/download" \
        -O/usr/lib/keepass2/plugins/FaviconDownloader.plgx || exit 1
    sudo wget "https://raw.github.com/pfn/keepasshttp/master/KeePassHttp.plgx" \
        -O/usr/lib/keepass2/plugins/KeePassHttp.plgx || exit 1

    # TrayTOTP has a custom build to fix interoperability with notification
    # plugin
    rm -rf /tmp/traytotp.zip
    wget "https://github.com/rmgrimm/traytotp-kp2/releases/download/v2.0.0.5nullcheck/TrayTOTPv2.0.0.5nullcheck.zip" \
        -O/tmp/traytotp.zip || exit 1
    sudo unzip -jo /tmp/traytotp.zip TrayTOTP.plgx \
        -d /usr/lib/keepass2/plugins || exit 1
    rm -f /tmp/traytotp.zip

    # Purge some nonsense
    sudo aptitude purge -y \
        unity-webapps-common || exit 1

    exit 0
}

if [ x"$1" = x"" ]; then
    add_repos || exit 1
    install_packages || exit 1
    exit 0
fi

case "$1" in
    repos) add_repos; exit $?; ;;
    packages) install_packages; exit $? ;;
    *) echo "Unrecognized command $1..."; exit 1 ;;
esac