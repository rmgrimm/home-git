PS1Time="\t"
PS1PathShort="\w"
PS1User="\u@\h"
PS1NewLine="\n"
if [ -f "/run/.containerenv" ] && [ -f "/run/.toolboxenv" ]; then
    PS1ToolboxIndicator="⬢ "
else
    PS1ToolboxIndicator=""
fi
