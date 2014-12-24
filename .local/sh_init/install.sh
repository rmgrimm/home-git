#!/bin/bash
# This is intended to be run from machines that don't yet have homedir
# tracked by git

if [ x"$HOME_GIT_ORIGIN" = x"" ]; then
    HOME_GIT_ORIGIN="https://github.com/rmgrimm/home-git.git"
fi

if ! which git >/dev/null; then
    if ! sudo -v; then
        echo "sudo failed; aborting."
        exit 1
    fi

    sudo apt-get install -y git
fi

rm -rf "$HOME/.local/git-home-temp"
mkdir -p "$HOME/.local/git-home-temp"
git clone "$HOME_GIT_ORIGIN" "$HOME/.local/git-home-temp"
pushd "$HOME/.local/git-home-temp"
git submodule update --init
popd

rsync -av "$HOME/.local/git-home-temp/" "$HOME/" 
rm -rf "$HOME/.local/git-home-temp"

if [ "$(id -nu)" = "robert" ]; then
    pushd "$HOME/.emacs.d"
    git remote set-url --push origin "ssh://git@github.com/rmgrimm/.emacs.d.git"
    popd
fi
