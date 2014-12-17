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
