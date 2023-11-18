
if
  command -v podman &>/dev/null
then
  export REGISTRY_AUTH_FILE="$HOME/.config/containers/auth.json"

  if
    [ -d "$HOME/.local/bin/podman" ] &&
    ! [[ "$PATH" =~ "$HOME/.local/bin/podman:" ]]
  then
    PATH="$HOME/.local/bin/podman:$PATH"
  fi
fi
