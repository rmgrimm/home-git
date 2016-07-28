#!/bin/bash

# Ideas borrowed from:
# https://github.com/jfrazelle/dotfiles/blob/fdff32b013f55bf4e78dbd89f5f2660f53aec687/.dockerfunc

__rmg_d_cleanup() {
  docker rm $(docker ps -aq 2>/dev/null) 2>/dev/null
  docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}
alias ,d-cleanup="__rmg_d_cleanup"

__rmg_d_del_stopped() {
  local state=$(docker inspect --format "{{.State.Running}}" $1 2>/dev/null)

  if [ "$state" = "false" ]; then
    docker rm $1 >/dev/null 2>&1
  fi
}

__rmg_d_run() {
  local DOCKER_IMAGE

  case "$(uname -m)" in
    x86) DOCKER_IMAGE=$1;;
    x86_64) DOCKER_IMAGE=$2;;
    armv7l) DOCKER_IMAGE=$3;;
  esac

  if [ -z "$DOCKER_IMAGE" -o "$DOCKER_IMAGE" = "-" ]; then
    echo "No image for this arch; aborting..."
    return 1
  fi

  shift 3

  local DOCKER_ARGS
  for arg in "$@"; do
    shift 1
    if [ "$arg" = "--" ]; then
      break
    fi

    DOCKER_ARGS="$DOCKER_ARGS\"$arg\" "
  done

  local COMMAND_ARGS
  for arg in "$@"; do
    shift 1
    COMMAND_ARGS="$COMMAND_ARGS\"$arg\" "
  done

  local DOCKER_NAME=$(echo $DOCKER_IMAGE | cut -d/ -f2)

  __rmg_d_del_stopped $DOCKER_NAME
  eval docker run $DOCKER_ARGS --name $DOCKER_NAME -- $DOCKER_IMAGE $COMMAND_ARGS
}
__rmg_d_run_cli() {
  local DOCKER_IMAGE=$1
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
