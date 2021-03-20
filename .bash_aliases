#!/bin/bash

# Default Debian ~/.bashrc will source ~/.bash_aliases if it exists
# and default ~/.profile will source ~/.bashrc when running in bash.

# Run custom bashrc parts
[ -r "$HOME/.opt/rmg-bash-init/source-bashrc-parts.sh" ] && \
  . "$HOME/.opt/rmg-bash-init/source-bashrc-parts.sh"
