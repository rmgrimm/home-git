#!/bin/bash

if [ -w "$HOME/.bashrc" ]
then
  # Ensure .bashrc is set to source the script that will run each part
  grep -q \
    -F '. "$HOME/.opt/rmg-bash-init/source-bashrc-parts.sh"' \
    "$HOME/.bashrc" || \
  cat >> "$HOME/.bashrc" << 'END_OF_INSERT'

# Run custom bashrc parts
[ -r "$HOME/.opt/rmg-bash-init/source-bashrc-parts.sh" ] && \
  . "$HOME/.opt/rmg-bash-init/source-bashrc-parts.sh"

END_OF_INSERT
fi

if [ -w "$HOME/.profile" ]
then
  # Ensure .profile is set to source the script that will run each part
  grep -q \
    -F '. "$HOME/.opt/rmg-bash-init/source-profile-parts.sh"' \
    "$HOME/.bashrc" || \
  cat >> "$HOME/.bashrc" << 'END_OF_INSERT'

# Run custom profile parts
[ -r "$HOME/.opt/rmg-bash-init/source-profile-parts.sh" ] && \
  . "$HOME/.opt/rmg-bash-init/source-profile-parts.sh"

END_OF_INSERT
fi
