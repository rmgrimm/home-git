#!/bin/bash

# Check for android studio
if [ -d "$HOME/.local/android-studio/bin" ] ; then
    PATH="$HOME/.local/android-studio/bin:$PATH"
fi

# Also check for android tools
if [ -d "$HOME/.local/android-sdk-linux/tools" ] ; then
    export ANDROID_HOME="$HOME/.local/android-sdk-linux"
    PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
fi

# Setup Oracle JDK
if [ -d "$HOME/.local/java" ] ; then
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
