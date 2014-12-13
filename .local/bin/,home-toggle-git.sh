#!/bin/bash

HOME_VCS_NORMAL="$HOME/.git"
HOME_VCS_STOWED="$HOME/.git-stowed"

if [ -d "$HOME_VCS_STOWED" ]; then
    mv "$HOME_VCS_STOWED" "$HOME_VCS_NORMAL" || exit 1
    echo "Home directory version control activated"
else
    mv "$HOME_VCS_NORMAL" "$HOME_VCS_STOWED" || exit 1
    echo "Home directory version control deactivated"
fi
