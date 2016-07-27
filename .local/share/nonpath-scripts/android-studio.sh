#!/bin/sh

if [ -e "$HOME/.local/share/sh_init/common_noninteractive.sh" ]; then
    . "$HOME/.local/share/sh_init/common_noninteractive.sh"
fi

exec "$HOME/.local/share/android-studio/bin/studio.sh" $@
