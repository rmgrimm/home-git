#!/bin/bash

if [ ! -d "$HOME/.local/tor-browser" ]; then
    if ! "$HOME/.local/nonpath-scripts/install-tor-browser.sh"; then
        echo
        echo "failed to install tor browser; exiting..."
        exit 1
    fi
fi

exec "$HOME/.local/tor-browser/start-tor-browser" "$@"
