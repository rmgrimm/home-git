
# Set up $DOCKER_HOST if podman, podman-docker and podman.sock are available
if
  command -v podman &>/dev/null &&
  command -v docker &>/dev/null &&
  [ -S "$XDG_RUNTIME_DIR/podman/podman.sock" ]
then
  export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
  export TESTCONTAINERS_RYUK_DISABLED=true
fi
