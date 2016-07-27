#!/bin/bash

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
       docker images -q >/dev/null 2>&1 && \
       [ -d "$HOME/.local/bin/docker" ]; then
    PATH="$HOME/.local/bin/docker:$PATH"

    if [ -f "$HOME/.local/bin/docker/.docker-init.sh" ]; then
        . "$HOME/.local/bin/docker/.docker-init.sh"
    fi
fi
