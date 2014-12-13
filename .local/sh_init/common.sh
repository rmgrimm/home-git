#!/bin/bash

# Turn off the annoying XON and XOFF from ctrl+s and ctrl+q
stty ixoff -ixon
stty start undef
stty stop undef

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

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Setup Node Version Manager only for amd64
if [ $(uname -m) == 'x86_64' -a -e "$HOME/.local/nvm/nvm.sh" ]; then
    source "$HOME/.local/nvm/nvm.sh"
    export NVM_DIR="$HOME/.local/node"
    nvm use default

    if [ -e "$HOME/.local/nvm/bash_completion" ]; then
        source "$HOME/.local/nvm/bash_completion"
    fi
fi

# Setup SSH agent
if [ -e "$HOME/.local/sshag/sshag.sh" ]; then
    source "$HOME/.local/sshag/sshag.sh"
    sshag
fi
