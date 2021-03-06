# Fedora on Crostini

Settings and home directory files for use when running Fedora on ChromeOS
with Crostini.

## Requirements

Prior to setting up, ensure that the following tools are available:

1. git
2. rsync

_Note: These should be installed already._

## Set Up

To set up this repository in home, run the following commands:

```shell
rm -rf "$HOME/.tmp/git-home-temp"
mkdir -p "$HOME/.tmp/git-home-temp"
git clone https://github.com/rmgrimm/home-git.git -b env/crostini/fedora --depth 1 --no-tags --recurse-submodules --shallow-submodules --remote-submodules "$HOME/.tmp/git-home-temp"
rsync -av "$HOME/.tmp/git-home-temp" "$HOME/"
rm -rf "$HOME/.tmp/git-home-temp"
rmdir --ignore-fail-on-non-empty "$HOME/.tmp/"

"$HOME/.opt/rmg-bash-init/install.sh"
```
