#!/bin/bash

VERSION_REGEXP="[[:digit:]]+\\.[[:digit:]]+\.[[:digit:]]+"

TOR_BROWSER_VERSION=$(
    curl "https://www.torproject.org/projects/torbrowser.html.en#downloads" \
    | grep --only-matching --extended-regexp \
        --regexp=">\\($VERSION_REGEXP\\)<" \
    | head --lines=1)
TOR_BROWSER_VERSION=${TOR_BROWSER_VERSION:2:-2}

# TODO(rgrimm): Get architecture (32/64)
TOR_BROWSER_FILE="tor-browser-linux64-${TOR_BROWSER_VERSION}_en-US.tar.xz"
TOR_BROWSER_URL="https://www.torproject.org/dist/torbrowser/${TOR_BROWSER_VERSION}/${TOR_BROWSER_FILE}"

mkdir -p "$HOME/Downloads" "$HOME/.local/tor-browser"
rm -f "$HOME/Downloads/${TOR_BROWSER_FILE}"
rm -f "$HOME/Downloads/${TOR_BROWSER_FILE}.asc"
wget "${TOR_BROWSER_URL}" -O"$HOME/Downloads/${TOR_BROWSER_FILE}"
wget "${TOR_BROWSER_URL}.asc" -O"$HOME/Downloads/${TOR_BROWSER_FILE}.asc"

gpg --keyserver x-hkp://pool.sks-keyservers.net --recv-keys 0x416F061063FEE659
gpg --verify "$HOME/Downloads/${TOR_BROWSER_FILE}.asc" \
    "$HOME/Downloads/${TOR_BROWSER_FILE}" || exit 1

tar --extract --xz --strip-components=1 \
    --directory "$HOME/.local/tor-browser/" \
    --file "$HOME/Downloads/${TOR_BROWSER_FILE}"
