#!/bin/bash

SDK_ROOT="$HOME/.local/share/android-sdk-linux"
SDK_VERSION="3859397"

if ! which java >/dev/null 2>&1 ; then
  echo "Java not found; aborting..."
  exit 1
fi

if [ ! -d "$SDK_ROOT/tools" ]; then
  mkdir -p "$SDK_ROOT"
  pushd "$SDK_ROOT"
  SDK_URL="http://dl.google.com/android/repository/sdk-tools-linux-$SDK_VERSION.zip"
  wget -Osdk.zip "$SDK_URL"
  unzip sdk.zip
  rm sdk.zip
  popd
fi

pushd "$HOME/.local/share"

case "$(uname -m)" in
  x86|x86_64)
  # swt.jar comes by default with Google package for x86/x64
  ;;
  armv7l)
    if [ ! -e "android-sdk-linux/tools/lib/arm/swt.jar" ]; then
      pushd "android-sdk-linux"

      # Download swt.jar from the Debian package
      ARM_SWT_PACKAGE_NAME=libswt-gtk-4-java
      mkdir -p tools/lib/arm
      apt-get download $ARM_SWT_PACKAGE_NAME
      ARM_SWT_VERSION=$(echo "$ARM_SWT_PACKAGE_NAME"*.deb | cut -d_ -f2 | cut -d- -f1)
      dpkg --fsys-tarfile "$ARM_SWT_PACKAGE_NAME"*.deb | tar xfO - './usr/lib/java/swt-gtk-'$ARM_SWT_VERSION'.jar' > tools/lib/arm/swt.jar
      rm -f "$ARM_SWT_PACKAGE_NAME"*.deb

      # TODO(rgrimm): Get/build platform tools for ARM
      # (or use binfmt-support with qemu-user-static + i386 arch)
      popd
    fi
    ;;
esac

android-sdk-linux/tools/bin/sdkmanager --sdk_root="$SDK_ROOT" \
                                       tools platform-tools

if sudo -v; then
  sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L \
       https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules
  sudo chmod a+r /etc/udev/rules.d/51-android.rules

  sudo systemctl restart udev
fi

popd
