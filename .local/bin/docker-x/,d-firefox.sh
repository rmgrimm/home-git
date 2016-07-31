#!/bin/sh

. .docker-init.sh

mkdir -p "$HOME/.local/share/firefox/"{cache,mozilla} 2>/dev/null

__rmg_d_run jess/firefox jess/firefox rmgrimm/armhf-firefox \
            --rmg-with-x \
            --rmg-multi \
            --memory 2gb \
            --net host \
            --cpuset-cpus 0 \
            --read-only \
            -v /etc/localtime:/etc/localtime:ro \
            -v "$HOME/.local/share/firefox/cache:$HOME/.cache/mozilla:rw" \
            -v "$HOME/.local/share/firefox/mozilla:$HOME/.mozilla:rw" \
            -v "$HOME/Downloads:$HOME/Downloads:rw" \
            -v "$HOME/Pictures:$HOME/Pictures:rw" \
            -e GDK_SCALE \
            -e GDK_DPI_SCALE \
            -e HOME \
            --device /dev/snd \
            --group-add audio \
            -- \
            "$@"
