#!/bin/bash

# Check for android studio
if [ -d "$HOME/.local/android-studio/bin" ]; then
    PATH="$HOME/.local/android-studio/bin:$PATH"
fi

# Also check for android tools
if [ -d "$HOME/.local/android-sdk-linux/tools" ]; then
    export ANDROID_HOME="$HOME/.local/android-sdk-linux"
    PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
fi

# Set up Oracle JDK
if [ -d "$HOME/.local/java" ]; then
    LATEST_JDK="$(/usr/bin/find $HOME/.local/java -maxdepth 1 -mindepth 1 -type d -iname jdk\* | /usr/bin/sort -r | /usr/bin/head -n 1)"
    if [ -n "$LATEST_JDK" ]; then
        export JAVA_HOME="$LATEST_JDK"
        export IDEA_JDK="$LATEST_JDK"
        export STUDIO_JDK="$IDEA_JDK"
        if [ -d "$LATEST_JDK/bin" ]; then
            PATH="$LATEST_JDK/bin:$PATH"
        fi
    fi
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
