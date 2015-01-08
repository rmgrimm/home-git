#!/bin/bash

if [ ! -d "$HOME/.local/android-studio" ]; then
    echo Android Studio not at "$HOME/.local/android-studio". Exiting.
    exit 1
fi

sed -r \
    -e 's/^(# )?idea.config.path=.*$/idea.config.path=\$\{user.home\}\/.local\/android-studio-local\/config/' \
    -e 's/^(# )?idea.system.path=.*$/idea.system.path=\$\{user.home\}\/.local\/android-studio-local\/system/' \
    -e 's/^(# )?idea.plugins.path=.*$/idea.plugins.path=\$\{idea.config.path\}\/plugins/' \
    -e 's/^(# )?idea.log.path=.*$/idea.log.path=\$\{idea.system.path\}\/log/' \
    -i "$HOME/.local/android-studio/bin/idea.properties"

if [ -d "$HOME/.AndroidStudio" ]; then
    rm -rf "$HOME/.AndroidStudio"
fi

if [ ! -f "$HOME/.local/share/applications/android-studio.desktop" ]; then
    cat > "$HOME/.local/share/applications/android-studio.desktop" <<EOF
[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=Android Studio
Comment=Android development IDE
Type=Application
Exec="$HOME/.local/nonpath-scripts/android-studio.sh" %f
Icon=$HOME/.local/android-studio/bin/androidstudio.svg
Terminal=false
Categories=Utility;Development;IDE
StartupNotify=true
StartupWMClass=jetbrains-android-studio
EOF
    chmod +x "$HOME/.local/share/applications/android-studio.desktop"
fi
