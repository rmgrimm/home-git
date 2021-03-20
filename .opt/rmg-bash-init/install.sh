#!/bin/bash

# Bash install skipped because Debian uses ~/.bash_aliases

if [ -w "$HOME/.profile" ]
then
  # Ensure .profile is set to source the script that will run each part
  grep -q \
    -F '. "$HOME/.opt/rmg-bash-init/source-profile-parts.sh"' \
    "$HOME/.profile" || \
  cat >> "$HOME/.profile" << 'END_OF_INSERT'

# Run custom profile parts
[ -r "$HOME/.opt/rmg-bash-init/source-profile-parts.sh" ] && \
  . "$HOME/.opt/rmg-bash-init/source-profile-parts.sh"

END_OF_INSERT
fi
