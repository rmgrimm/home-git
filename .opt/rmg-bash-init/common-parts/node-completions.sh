
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
    [ ! -e "$HOME/.bash_completion.d/node" ] &&
    [ ! -e "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion/node" ] 
  then
    source <(node --completion-bash)
  fi

  # Load npm completions if not generated as a file
  if
    command -v npm &>/dev/null &&
    [ ! -e "$HOME/.bash_completion.d/npm" ] &&
    [ ! -e "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion/npm" ]
  then
    source <(npm completion)
  fi

  # Load pnpm completions
  if
    command -v pnpm &>/dev/null &&
    [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion.d.rmg/pnpm" ]
  then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion.d.rmg/pnpm"
  fi
fi

