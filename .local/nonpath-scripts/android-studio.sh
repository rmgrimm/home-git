#!/bin/sh

if [ -e "$HOME/.local/sh_init/common_noninteractive.sh" ]; then
    . "$HOME/.local/sh_init/common_noninteractive.sh"
fi

exec "$HOME/.local/android-studio/bin/studio.sh" $@
