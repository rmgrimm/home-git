#!/bin/sh

. .docker-init.sh

__rmg_d_run jess/tor-browser jess/tor-browser - \
            --rmg-with-x \
            --rmg-multi \
            --read-only \
            -v /etc/localtime:/etc/localtime:ro \
            -e GDK_SCALE \
            -e GDK_DPI_SCALE \
            --device /dev/snd \
            -- \
            "$@"
