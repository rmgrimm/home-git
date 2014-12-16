#!/bin/bash

SDK_VERSION="r24.0.1"

pushd "$HOME/.local"

if [ ! -d "$HOME/.local/android-sdk-linux" ]; then
    SDK_URL="http://dl.google.com/android/android-sdk_$SDK_VERSION-linux.tgz"
    wget -O- "$SDK_URL" | tar xz
fi

android-sdk-linux/tools/android update sdk --no-ui

popd
