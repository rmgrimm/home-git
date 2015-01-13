#!/bin/bash

if [ ! -d "$HOME/.local/tor-browser" ]; then
    "$HOME/.local/nonpath-scripts/install-tor-browser.sh"
fi

exec "$HOME/.local/tor-browser/start-tor-browser "$@"
