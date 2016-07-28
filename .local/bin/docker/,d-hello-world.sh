#!/bin/sh

. .docker-init.sh

__rmg_d_run hello-world hello-world armhf/hello-world --rm -it -- "$@"
