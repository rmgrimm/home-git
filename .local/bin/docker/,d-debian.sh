#!/bin/bash

. .docker-init.sh

# Just a quick example to run different versions of debian across
# different platforms

# TODO(rmgrimm): Add images for x86 and x86_64
__rmg_d_run - - armv7/armhf-debian -it "$@"
