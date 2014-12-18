#!/bin/bash

# Start with all the non-interactive stuff
if [ -x "$HOME/.local/sh_init/common_noninteractive.sh" ]; then
    . "$HOME/.local/sh_init/common_noninteractive.sh"
fi

# Turn off the annoying XON and XOFF from ctrl+s and ctrl+q
stty ixoff -ixon
stty start undef
stty stop undef

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Setup Node Version Manager only for amd64
if [ $(uname -m) == 'x86_64' -a -e "$HOME/.local/nvm/nvm.sh" ]; then
    . "$HOME/.local/nvm/nvm.sh"
    export NVM_DIR="$HOME/.local/node"
    mkdir -p "$HOME/.local/node"
    nvm use default

    if [ -e "$HOME/.local/nvm/bash_completion" ]; then
        . "$HOME/.local/nvm/bash_completion"
    fi
fi

# Setup SSH agent
if [ -e "$HOME/.local/sshag/sshag.sh" ]; then
    . "$HOME/.local/sshag/sshag.sh"
    sshag_init
fi
