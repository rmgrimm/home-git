#!/bin/bash

SDK_VERSION="r24.4.1"

if ! which java >/dev/null 2>&1 ; then
    echo "Java not found; aborting..."
    exit 1
fi

pushd "$HOME/.local/share"

if [ ! -d "$HOME/.local/share/android-sdk-linux/tools" ]; then
    SDK_URL="http://dl.google.com/android/android-sdk_$SDK_VERSION-linux.tgz"
    wget -O- "$SDK_URL" | tar xz
fi

case "$(uname -m)" in
x86|x86_64) ;;
armv7l)
    if [ ! -e "android-sdk-linux/tools/lib/arm/swt.jar" ]; then
        ARM_SWT_PACKAGE_NAME=libswt-gtk-4-java
        pushd "android-sdk-linux"
        mkdir -p tools/lib/arm
        apt-get download $ARM_SWT_PACKAGE_NAME
        ARM_SWT_VERSION=$(echo "$ARM_SWT_PACKAGE_NAME"*.deb | cut -d_ -f2 | cut -d- -f1)
        dpkg --fsys-tarfile "$ARM_SWT_PACKAGE_NAME"*.deb | tar xfO - './usr/lib/java/swt-gtk-'$ARM_SWT_VERSION'.jar' > tools/lib/arm/swt.jar
        rm -f "$ARM_SWT_PACKAGE_NAME"*.deb
        popd
    fi
    ;;
esac

android-sdk-linux/tools/android update sdk --no-ui \
    --filter tool,platform-tool

if sudo -v; then
    sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L \
        https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules
    sudo chmod a+r /etc/udev/rules.d/51-android.rules

    sudo service udev restart
fi

popd
