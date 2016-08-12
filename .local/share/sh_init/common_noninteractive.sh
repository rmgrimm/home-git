#!/bin/bash

# Check for Windows Subsystem for Linux (WSL; aka "Bash on Windows 10")
if grep -qF Microsoft /proc/version || \
    find /dev -mindepth 1 -maxdepth 1 | grep -qF lxss
then
    export WINDOWS_SUBSYSTEM_FOR_LINUX=1

    # Set up DISPLAY on WSL
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=localhost:0
        export LIBGL_ALWAYS_INDIRECT=1
    fi

    if which xrdb >/dev/null 2>&1 && \
        [ -r "$HOME/.Xresources" ]
    then
        xrdb -merge "$HOME/.Xresources" >/dev/null 2>&1
    fi
fi

# Check for android studio
if [ -d "$HOME/.local/share/android-studio/bin" ]; then
    PATH="$HOME/.local/share/android-studio/bin:$PATH"
fi

# Also check for android tools
if [ -z "$ANDROID_HOME" ]; then
    ANDROID_HOME="$HOME/.local/share/android-sdk-linux"
    if [ -d "$ANDROID_HOME/tools" ]; then
        export ANDROID_HOME
        PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
    else
        unset ANDROID_HOME
    fi
fi

# Set up Oracle JDK
if [ -z "$JAVA_HOME" -a -d "$HOME/.local/java" ]; then
    LATEST_JDK="$(/usr/bin/find $HOME/.local/java -maxdepth 1 -mindepth 1 -type d -iname jdk\* | /usr/bin/sort -r | /usr/bin/head -n 1)"
    if [ -n "$LATEST_JDK" ]; then
        export JAVA_HOME="$LATEST_JDK"
        export IDEA_JDK="$LATEST_JDK"
        export STUDIO_JDK="$IDEA_JDK"
        if [ -d "$LATEST_JDK/bin" ]; then
            PATH="$LATEST_JDK/bin:$PATH"
        fi
    fi
    unset LATEST_JDK
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Set up some docker helpers (override other private bin items)
if which docker >/dev/null 2>&1 && \
       docker images -q >/dev/null 2>&1
then
    # Command-line docker
    if [ -d "$HOME/.local/bin/docker" ]; then
        PATH="$HOME/.local/bin/docker:$PATH"

        if [ -r "$HOME/.local/bin/docker/.docker-init.sh" ]; then
            . "$HOME/.local/bin/docker/.docker-init.sh"
        fi
    fi

    # X11-based docker
    if [ -n "$DISPLAY" -a -d "$HOME/.local/bin/docker-x" ]; then
        PATH="$HOME/.local/bin/docker-x:$PATH"

        if [ -r "$HOME/.local/bin/docker-x/.docker-init.sh" ]; then
            . "$HOME/.local/bin/docker-x/.docker-init.sh"
        fi
    fi
fi
