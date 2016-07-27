#!/bin/bash

. .docker-init.sh

__rmg_d_run jess/tor-browser jess/tor-browser - \
            -d \
            -v /etc/localtime:/etc/localtime:ro \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -e DISPLAY=unix$DISPLAY \
            -e GDK_SCALE \
            -e GDK_DPI_SCALE \
            --device /dev/snd
