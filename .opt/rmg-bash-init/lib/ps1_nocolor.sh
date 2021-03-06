. "$HOME/.opt/rmg-bash-init/lib/ps1_elements.sh"

PS1=$PS1NewLine'${debian_chroot:+($debian_chroot)}'
PS1=$PS1$PS1Time' '$PS1User$PS1NewLine
PS1=$PS1$PS1ToolboxIndicator
PS1=$PS1$PS1PathShort'\$ '
