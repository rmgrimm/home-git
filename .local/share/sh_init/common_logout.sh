#!/bin/bash

# Tear down for Windows Subsystem for Linux (WSL)
if [ "$WINDOWS_SUBSYSTEM_FOR_LINUX" = 1 ]; then

    if [ -n "$SSH_AUTH_SOCAT_PID" ]; then
        kill "$SSH_AUTH_SOCAT_PID" >/dev/null 2>&1
    fi

    if [ -S "$SSH_AUTH_SOCK" ]; then
        rm -f $SSH_AUTH_SOCK >/dev/null 2>&1
        rmdir $(dirname $SSH_AUTH_SOCK) >/dev/null 2>&1
    fi
fi
