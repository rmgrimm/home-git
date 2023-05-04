
# Don't bother if not running interactively
case $- in
  *i*) ;;
  *) return ;;
esac

# Test for known color support
case "$TERM" in
  xterm|xterm-color|xterm-256color) color_prompt=yes ;;
  screen) color_prompt=yes ;;
esac

# Test for terminal color support
if
  [ -z "$color_prompt" ]
then
  if
    [ -x "/usr/bin/tput" ] &&
    tput setaf 1 >&/dev/null
  then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  fi
fi

if
  [ "$color_prompt" = yes ]
then
  . "$HOME/.opt/rmg-bash-init/lib/ps1_color.sh"
else
  . "$HOME/.opt/rmg-bash-init/lib/ps1_nocolor.sh"
fi

# Set title on xterm
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
  ;;
  *)
  ;;
esac

unset color_prompt
