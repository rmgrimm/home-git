#!/bin/sh

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
    x86) DOCKER_IMAGE=$1 ;;
    x86_64) DOCKER_IMAGE=$2 ;;
    armv7l) DOCKER_IMAGE=$3 ;;
  esac

  if [ -z "$DOCKER_IMAGE" -o "$DOCKER_IMAGE" = "-" ]; then
    echo "No image for this arch; aborting..."
    return 1
  fi

  shift 3

  local DOCKER_NAME=$(echo $DOCKER_IMAGE | cut -d/ -f2)

  local RMG_DEBUG=n
  local RMG_MULTI_CONTAINER=n
  local RMG_WITH_X=n
  local DOCKER_DEFAULT_USER=y
  local DOCKER_ARGS=""
  for arg in "$@"; do
    shift 1

    if [ "$arg" = "--rmg-with-x" ]; then
      RMG_WITH_X=y
      continue
    elif [ "$arg" = "--rmg-multi" ]; then
      RMG_MULTI_CONTAINER=y
      continue
    elif [ "$arg" = "--rmg-debug" ]; then
      RMG_DEBUG=y
      continue
    elif [ "$arg" = "--user" ]; then
      DOCKER_DEFAULT_USER=n
    elif [ "$arg" = "--" ]; then
      break
    fi

    DOCKER_ARGS="$DOCKER_ARGS\"$arg\" "
  done

  if [ "$DOCKER_DEFAULT_USER" = "y" ]; then
    DOCKER_ARGS="$DOCKER_ARGS'--user' '$(id -u):$(id -g)' "
  fi

  if [ "$RMG_MULTI_CONTAINER" = "y" ]; then
    local FIELD_POS=$((2 + $(echo $DOCKER_NAME | grep -oF - - | wc -l)))
    local NUM_CONTAINERS=$(\
      docker ps -a -f 'name='$DOCKER_NAME\* \
             --format {{.Names}} | \
        cut -d- -f$FIELD_POS | sort -n | tail -n1)
    if [ -z "$NUM_CONTAINERS" ]; then
      NUM_CONTAINERS=-1
    fi
    DOCKER_NAME="$DOCKER_NAME-$((1 + $NUM_CONTAINERS))"
  else
    __rmg_d_del_stopped $DOCKER_NAME
  fi

  local COMMAND_ARGS=""
  for arg in "$@"; do
    shift 1
    COMMAND_ARGS="$COMMAND_ARGS\"$arg\" "
  done

  if [ "$RMG_WITH_X" = "y" ]; then
    local XAUTH="/tmp/.rmg.d-$DOCKER_NAME.xauth"
    touch $XAUTH
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

    DOCKER_ARGS="$DOCKER_ARGS'--detach' "
    DOCKER_ARGS="$DOCKER_ARGS'-v' '/tmp/.X11-unix:/tmp/.X11-unix:rw' "
    DOCKER_ARGS="$DOCKER_ARGS'-v' '$XAUTH:/tmp/.Xauthority:ro' "
    DOCKER_ARGS="$DOCKER_ARGS'-e' 'XAUTHORITY=/tmp/.Xauthority' "
    DOCKER_ARGS="$DOCKER_ARGS'-e' 'DISPLAY=unix$DISPLAY' "
  fi

  if [ "$RMG_DEBUG" = "y" ]; then
    echo eval docker run $DOCKER_ARGS --name $DOCKER_NAME -- $DOCKER_IMAGE $COMMAND_ARGS
  else
    eval docker run $DOCKER_ARGS --name $DOCKER_NAME -- $DOCKER_IMAGE $COMMAND_ARGS
  fi
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
