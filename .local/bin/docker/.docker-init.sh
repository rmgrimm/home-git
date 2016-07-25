#!/bin/bash

# Ideas borrowed from:
# https://github.com/jfrazelle/dotfiles/blob/fdff32b013f55bf4e78dbd89f5f2660f53aec687/.dockerfunc

___d_cleanup() {
  docker rm $(docker ps -aq 2>/dev/null) 2>/dev/null
  docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}
alias ,d-cleanup="___d_cleanup"

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
