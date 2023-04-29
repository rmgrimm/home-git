. "$HOME/.opt/rmg-bash-init/lib/colors.sh"
. "$HOME/.opt/rmg-bash-init/lib/ps1_elements.sh"

PS1ColorUser=$PSColorPre$Cyan$PSColorPost
PS1ColorUser=$PS1ColorUser$PS1User
PS1ColorUser=$PS1ColorUser$PSColorPre$Color_Off$PSColorPost

if [ -e "/usr/lib/git-core/git-sh-prompt" ]; then
  . "/usr/lib/git-core/git-sh-prompt"
  HaveGit=1
elif [ -e "/usr/share/git/completion/git-prompt.sh" ]; then
  . "/usr/share/git/completion/git-prompt.sh"
  HaveGit=1
elif [ -e "/usr/share/git-core/contrib/completion/git-prompt.sh" ]; then
  . "/usr/share/git-core/contrib/completion/git-prompt.sh"
  HaveGit=1
fi

PS1=$PSColorPre$IBlack$PSColorPost$PS1Time$PSColorPre$Color_Off$PSColorPost
if [ $HaveGit ]; then
  PS1=$PS1'$(git rev-parse --top-level >/dev/null 2>&1 ;'
  PS1=$PS1'if [ $? -eq 0 ]; then'
  PS1=$PS1'  echo "$(git status | grep -q "nothing to commit";'
  PS1=$PS1'  if [ $? -eq 0 ]; then'
  PS1=$PS1'    echo "'$PSColorPre$Green$PSColorPost'"$(__git_ps1 " (%s)");'
  PS1=$PS1'  else'
  PS1=$PS1'    echo "'$PSColorPre$IRed$PSColorPost'"$(__git_ps1 " (%s)");'
  PS1=$PS1'  fi) '$PS1ColorUser
  if [ -n "$PS1ContainerIndicator" ]; then
      PS1=$PS1$PSColorPre$Purple$PSColorPost$PS1ContainerIndicator
  fi
  PS1=$PS1$PS1NewLine
  PS1=$PS1$PSColorPre$BYellow$PSColorPost$PS1PathShort
  PS1=$PS1$PSColorPre$Color_Off$PSColorPost'\$ ";'
  PS1=$PS1'else'
  PS1=$PS1'  echo "'
fi
PS1=$PS1' '$PS1ColorUser
if [ -n "$PS1ContainerIndicator" ]; then
    PS1=$PS1$PSColorPre$Purple$PSColorPost$PS1ContainerIndicator
fi
PS1=$PS1$PS1NewLine
PS1=$PS1$PSColorPre$Yellow$PSColorPost$PS1PathShort
PS1=$PS1$PSColorPre$Color_Off$PSColorPost'\$ '
if [ $HaveGit ]; then
  PS1=$PS1'";'
  PS1=$PS1'fi)'
fi
