#!/bin/bash

source "$HOME/.local/sh_init/colors.sh"
source "$HOME/.local/sh_init/ps1_elements.sh"

PS1ColorUser=$Cyan$PS1User$Color_Off

if [ -e "/etc/bash_completion.d/git" \
    -o -e "/etc/bash_completion.d/git-prompt" ]; then
  HaveGit=1
fi

PS1='${debian_chroot:+($debian_chroot)}'
PS1=$PS1$IBlack$PS1Time$Color_Off
if [ $HaveGit ]; then
  PS1=$PS1'$(git rev-parse --top-level > /dev/null;'
  PS1=$PS1'if [ $? -eq 0 ]; then'
  PS1=$PS1'  echo "$(git status | grep -q "nothing to commit";'
  PS1=$PS1'  if [ $? -eq 0 ]; then'
  PS1=$PS1'    echo "'$Green'"$(__git_ps1 " (%s)");'
  PS1=$PS1'  else'
  PS1=$PS1'    echo "'$IRed'"$(__git_ps1 " (%s)");'
  PS1=$PS1'  fi) '$PS1ColorUser$PS1NewLine$BYellow$PS1PathShort$Color_Off'\$ ";'
  PS1=$PS1'else'
  PS1=$PS1'  echo "'
fi
PS1=$PS1' '$PS1ColorUser$PS1NewLine$Yellow$PS1PathShort$Color_Off'\$ '
if [ $HaveGit ]; then
  PS1=$PS1'";'
  PS1=$PS1'fi)'
fi
