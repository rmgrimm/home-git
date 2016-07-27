#!/bin/bash

SDK_VERSION="r24.0.1"

if ! which java ; then
    echo "Java not found; aborting..."
    exit 1
fi

pushd "$HOME/.local"

if [ ! -d "$HOME/.local/android-sdk-linux" ]; then
    SDK_URL="http://dl.google.com/android/android-sdk_$SDK_VERSION-linux.tgz"
    wget -O- "$SDK_URL" | tar xz
fi

android-sdk-linux/tools/android update sdk --no-ui \
    --filter tool,platform-tool

if sudo -v; then
    sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L \
        https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules
    sudo chmod a+r /etc/udev/rules.d/51-android.rules

    sudo service udev restart
fi

popd
