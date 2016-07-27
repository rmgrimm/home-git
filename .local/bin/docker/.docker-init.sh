#!/bin/bash

# Ideas borrowed from:
# https://github.com/jfrazelle/dotfiles/blob/fdff32b013f55bf4e78dbd89f5f2660f53aec687/.dockerfunc

__rmg_d_cleanup() {
    docker rm $(docker ps -aq 2>/dev/null) 2>/dev/null
    docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}
alias ,d-cleanup="__rmg_d_cleanup"

__rmg_d_run() {
    case "$(uname -m)" in
        x86) DOCKER_IMAGE=$1;;
        x86_64) DOCKER_IMAGE=$2;;
        armv7l) DOCKER_IMAGE=$3;;
    esac

    if [ -z "$DOCKER_IMAGE" -o "$DOCKER_IMAGE" = "-" ]; then
        return 1
    fi

    shift 3

    DOCKER_NAME=$(echo $DOCKER_IMAGE | cut -d/ -f2)

    docker run "$@" --name $DOCKER_NAME $DOCKER_IMAGE
}
__rmg_d_run_cli() {
    DOCKER_IMAGE=$1
    shift
    __rmg_d_run "$DOCKER_IMAGE" "$DOCKER_IMAGE" "$DOCKER_IMAGE" "$@"
}
alias ,d-run="__rmg_d_run_cli"

# If running interactively, message the user that docker is ready
case $- in
*i*)
    if [ -n "$Color_Off" ]; then
        echo -e "Docker ready; commands start with "$BCyan",d-"$Color_Off
    else
        echo "Docker ready; commands start with ,d-"
    fi
    ;;
esac
