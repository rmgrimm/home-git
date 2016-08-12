#!/bin/bash

# Check for Windows Subsystem for Linux (WSL; aka "Bash on Windows 10")
# (duplicated here to also fix colors on WSL)
if grep -qF Microsoft /proc/version || \
    find /dev -mindepth 1 -maxdepth 1 | grep -qF lxss
then
    export WINDOWS_SUBSYSTEM_FOR_LINUX=1
fi

# Gnome Terminal and WSL both still report 8color mode... ugh. why?
if [ "$COLORTERM" = "gnome-terminal" -o \
    "$WINDOWS_SUBSYSTEM_FOR_LINUX" = 1 ]
then
    # Yes, this is a hack; the terminal should report this properly.
    case $TERM in
        *-256color) ;;
        screen*|xterm*)
            TERM=$TERM-256color
            ;;
    esac
    force_color_prompt=y
fi

# Start with all the non-interactive stuff
if [ -r "$HOME/.local/share/sh_init/common_noninteractive.sh" ]; then
    . "$HOME/.local/share/sh_init/common_noninteractive.sh"
fi

# Turn off the annoying XON and XOFF from ctrl+s and ctrl+q
stty ixoff -ixon
stty start undef
stty stop undef

# Run some set up for Windows
if [ "$WINDOWS_SUBSYSTEM_FOR_LINUX" = 1 ]; then
    echo -e "Running in "$IBlue"Windows Subsystem for Linux"$Color_Off"."

    # Idea for KeeAgent usage from https://github.com/dlech/KeeAgent/issues/159
    if which socat >/dev/null 2>&1 && \
        [ -z "$SSH_AUTH_SOCK" -a -r "/mnt/c/Opt/keeagent.sock" ]
    then
        SSH_AUTH_KEEAGENT_SOCK=/mnt/c/Opt/keeagent.sock
        SSH_AUTH_KEEAGENT_PORT=$(sed -r 's/!<socket >([0-9]*\b).*/\1/' $SSH_AUTH_KEEAGENT_SOCK)

        # Use socket filename structure similar to ssh-agent
        SSH_AUTH_TMPDIR=$(mktemp --tmpdir --directory keeagent-ssh.XXXXXXXXXX)
        SSH_AUTH_SOCK="$SSH_AUTH_TMPDIR/agent.$$"

        socat UNIX-LISTEN:${SSH_AUTH_SOCK},mode=0600,fork,shut-down TCP:127.0.0.1:${SSH_AUTH_KEEAGENT_PORT},connect-timeout=2 >/dev/null 2>&1 &
        export SSH_AUTH_SOCAT_PID=$!

        export SSH_AUTH_SOCK

        unset SSH_AUTH_KEEAGENT_SOCK
        unset SSH_AUTH_KEEAGENT_PORT
        unset SSH_AUTH_TMPDIR
    fi

    # Ensure that "logout" code is run on exit
    __rmg_wsl_trap_exit() {
        . "$HOME/.bash_logout"
    }
    trap __rmg_wsl_trap_exit EXIT
fi

# Setup Node Version Manager only for specific platforms
if [ -r "$HOME/.local/share/nvm/nvm.sh" ]; then
    case $(uname -m) in
    x86_64|armv7l)
        ,load-nvm() {
            . "$HOME/.local/share/nvm/nvm.sh"
            export NVM_DIR="$HOME/.local/share/node"
            mkdir -p "$HOME/.local/share/node"
            nvm use default

            if [ -r "$HOME/.local/share/nvm/bash_completion" ]; then
                . "$HOME/.local/share/nvm/bash_completion"
            fi
        }

        if [ -n "$Color_Off" ]; then
            echo -e "Note: NVM can be loaded with" \
                 $BCyan",load-nvm"$Color_Off
        else
            echo "Note: NVM can be loaded with ,load-nvm"
        fi
        ;;
    *)
        if [ -n "$Color_Off" ]; then
            echo -e "Note: NVM not tested on " \
                 $BCyan"$(uname -m)"$Color_Off";" \
                 "NVM unavailable"
        else
            echo "Note: NVM not tested on $(uname -m); NVM unavailable"
        fi
    esac
fi

# Setup SSH agent
if [ \( -z "$WINDOWS_SUBSYSTEM_FOR_LINUX" -o -n "$SSH_AUTH_SOCK" \) -a \
    -r "$HOME/.local/share/sshag/sshag.sh" ]
then
    . "$HOME/.local/share/sshag/sshag.sh"
    sshag_init
fi

# Use sensible editor with git
if which sensible-editor >/dev/null 2>&1; then
    export GIT_EDITOR="$(which sensible-editor)"
fi
