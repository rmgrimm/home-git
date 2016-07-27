#!/bin/bash

if [ ! -x "$HOME/.local/share/tor-browser/start-tor-browser" ]; then
    if ! "$HOME/.local/share/tor-browser/install-tor-browser.sh"; then
        echo
        echo "failed to install tor browser; exiting..."
        exit 1
    fi
fi

exec "$HOME/.local/share/tor-browser/start-tor-browser" "$@"
