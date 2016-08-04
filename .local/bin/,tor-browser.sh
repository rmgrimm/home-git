#!/bin/bash

if [ ! -x "$HOME/.local/share/tor-browser/Browser/start-tor-browser.desktop" ]
then
    if ! "$HOME/.local/share/tor-browser/install-tor-browser.sh"; then
        echo
        echo "failed to install tor browser; exiting..."
        exit 1
    fi
fi

exec "$HOME/.local/share/tor-browser/Browser/start-tor-browser" --verbose "$@"
