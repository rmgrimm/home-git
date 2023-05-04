
# Don't bother if not running interactively
case $- in
  *i*) ;;
  *) return ;;
esac

# Load node-related completions...
if
  command -v node &>/dev/null
then
  # Load node completions if not generated as a file
  if
    [ ! -e "$HOME/.bash_completions.d/node" ]
  then
    source <(node --completion-bash)
  fi

  # Load npm completions if not generated as a file
  if
    command -v npm &>/dev/null &&
    [ ! -e "$HOME/.bash_completions.d/npm" ]
  then
    source <(npm completion)
  fi

fi

