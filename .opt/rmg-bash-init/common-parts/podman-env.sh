
if
  command -v podman &>/dev/null
then
  export REGISTRY_AUTH_FILE="$HOME/.config/containers/auth.json"
fi
