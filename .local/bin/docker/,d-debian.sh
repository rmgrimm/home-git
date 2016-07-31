#!/bin/sh

. .docker-init.sh

# Just a quick example to run different versions of debian across
# different platforms

# Args: <x86 image> <x86_64 image> <armv7l image> [[docker args] \
#   -- [command [args]]]
__rmg_d_run debian debian armv7/armhf-debian \
            --rmg-multi \
            --user root:root \
            -it \
            -- \
            "$@"
