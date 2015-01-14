#!/bin/bash

VERSION_REGEXP="[[:digit:]]+\\.[[:digit:]]+\.[[:digit:]]+"

case $(uname -i) in
    x86_64) TOR_BROWSER_ARCH=linux64 ;;
    x86) TOR_BROWSER_ARCH=linux32 ;;
    *) echo "unknown arch; aborting install..."; exit 1
esac

if [ x"$1" = x"" ]; then
    TOR_BROWSER_VERSION=$(
        curl --silent \
            "https://www.torproject.org/projects/torbrowser/RecommendedTBBVersions" \
            | grep --only-matching --extended-regexp \
            --regexp="\".+\\-Linux\"," \
            | head --lines=1)
    TOR_BROWSER_VERSION=${TOR_BROWSER_VERSION:1:-8}
else
    TOR_BROWSER_VERSION="$1"
fi

echo "Installing Tor Browser bundle v${TOR_BROWSER_VERSION}..."

TOR_BROWSER_FILE="tor-browser-${TOR_BROWSER_ARCH}-${TOR_BROWSER_VERSION}_en-US.tar.xz"
TOR_BROWSER_URL="https://www.torproject.org/dist/torbrowser/${TOR_BROWSER_VERSION}/${TOR_BROWSER_FILE}"

mkdir -p "$HOME/Downloads"
rm -f "$HOME/Downloads/${TOR_BROWSER_FILE}"
rm -f "$HOME/Downloads/${TOR_BROWSER_FILE}.asc"

echo "  Downloading ${TOR_BROWSER_FILE}..."
wget --quiet "${TOR_BROWSER_URL}" \
    --output-document="$HOME/Downloads/${TOR_BROWSER_FILE}"
wget --quiet "${TOR_BROWSER_URL}.asc" \
    --output-document="$HOME/Downloads/${TOR_BROWSER_FILE}.asc"
echo "  Downloading ${TOR_BROWSER_FILE}...done."

echo "  Downloading key and verifying ${TOR_BROWSER_FILE}..."
gpg --keyserver x-hkp://pool.sks-keyservers.net \
    --recv-keys 0x416F061063FEE659 \
    || (echo "download failed; aborting..."; false) || exit 1
gpg --verify "$HOME/Downloads/${TOR_BROWSER_FILE}.asc" \
    "$HOME/Downloads/${TOR_BROWSER_FILE}" \
    || (echo "failed; aborting..."; false) || exit 1
echo "  Downloading key and verifying ${TOR_BROWSER_FILE}...done."

echo "  Extracting ${TOR_BROWSER_FILE}..."
mkdir -p "$HOME/.local/tor-browser"
tar --extract --xz --strip-components=1 \
    --directory "$HOME/.local/tor-browser/" \
    --file "$HOME/Downloads/${TOR_BROWSER_FILE}"
echo "  Extracting ${TOR_BROWSER_FILE}...done."

rm -f "$HOME/Downloads/${TOR_BROWSER_FILE}"
rm -f "$HOME/Downloads/${TOR_BROWSER_FILE}.asc"

echo "Installing Tor Browser bundle v${TOR_BROWSER_VERSION}...done."
