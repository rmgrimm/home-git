PS1Time="\t"
PS1PathShort="\w"
PS1User="\u@crouton"
PS1NewLine="\n"
PS1ContainerIndicator='${debian_chroot:+($debian_chroot)}'
if [ -f "/run/.containerenv" ] && [ -f "/run/.toolboxenv" ]; then
    PS1ContainerIndicator=$PS1ContainerIndicator"⬢"
fi
