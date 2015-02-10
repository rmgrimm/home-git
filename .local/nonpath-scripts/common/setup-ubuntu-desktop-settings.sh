#!/bin/bash

setup_autostart () {
    # Don't hide any autostart items
    sudo sed -i -e 's/NoDisplay=true/NoDisplay=false/' \
        /etc/xdg/autostart/*.desktop || exit 1

    # Don't autostart GNOME's half-implemented SSH agent
    mkdir -p "$HOME/.config/autostart"
    cp /etc/xdg/autostart/gnome-keyring-ssh.desktop \
        "$HOME/.config/autostart/gnome-keyring-ssh.desktop" || exit 1
    echo "X-GNOME-Autostart-enabled=false" | \
        tee -a "$HOME/.config/autostart/gnome-keyring-ssh.desktop"

    # No really, I don't want GNOME keyring ssh-agent started.
    mkdir -p "$HOME/.config/upstart"
    echo manual | tee "$HOME/.config/upstart/gnome-keyring.override"

    # Let Keepass2 autostart
    cp /usr/share/applications/keepass2.desktop \
        "$HOME/.config/autostart/keepass2.desktop" || exit 1
    echo "X-GNOME-Autostart-enabled=true" | \
        tee -a "$HOME/.config/autostart/keepass2.desktop"

    # Copy emacs desktop file, then set it to use emacsclient
    mkdir -p "$HOME/.local/share/applications"
    cp /usr/share/applications/emacs24.desktop \
        "$HOME/.local/share/applications/emacs24.desktop" || exit 1
    sed -i -r \
        -e "s/^Exec=.+[[:space:]]/Exec=\/usr\/bin\/emacsclient.emacs24 --alternate-editor=\"\" --create-frame /" \
        -e "s/^TryExec=.+$/TryExec=emacsclient.emacs24/" \
        "$HOME/.local/share/applications/emacs24.desktop" || exit 1

    exit 0
}

general_settings () {
    # Remove some bad settings
    gsettings set com.canonical.Unity.Lenses remote-content-search 'none'

    # Otherwise set up preferred look/feel of desktop
    gsettings set org.freedesktop.ibus.panel lookup-table-orientation 0
    gsettings set org.gnome.desktop.input-sources sources "[ \
        ('xkb', 'us'), \
        ('ibus', 'pinyin')]"
    gsettings set org.gnome.desktop.background color-shading-type 'solid'
    gsettings set org.gnome.desktop.background picture-options 'none'
    gsettings set org.gnome.desktop.background primary-color '#000000000000'
    gsettings set org.gnome.desktop.media-handling automount false
    gsettings set org.gnome.desktop.media-handling automount-open false
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[ \
        '<Super>space']"
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward \
        "['<Shift><Super>space']"

    exit 0
}

unity_settings () {
    # Remove some bad settings
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
    gsettings set org.gnome.DejaDup prompt-check 'disabled'
    gsettings set org.gnome.gnome-system-monitor cpu-stacked-area-chart true
    gsettings set org.gnome.gnome-system-monitor show-all-fs true
    gsettings set org.gnome.gnome-system-monitor show-tree true
    gsettings set org.gnome.Vino icon-visibility 'always'

    # Settings without schema
    dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 32

    # Settings in old-style gconf (dconf replaces gconf)
    gconftool-2 --set --type=bool \
        /apps/gnome-terminal/global/use_menu_accelerators \
        false
    gconftool-2 --set --type=bool \
        /apps/gnome-terminal/global/use_mnemonics \
        false

    exit 0
}

lxde_settings () {
    # Most of this is handled by settings files in $HOME/.config/...

    exit 0
}

setup_autostart || exit 1
general_settings || exit 1

case "$GDMSESSION" in
    Ubuntu) unity_settings || exit 1 ;;
    Lubuntu) lxde_settings || exit 1 ;;
esac

exit 0