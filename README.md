# Fedora

Settings and home directory files for use when running Fedora on bare metal
computers (laptops, desktops, servers). This also works for Fedora-like
distributions such as Silverblue, Kinoite, etc.

## Requirements

Prior to setting up, ensure that the following tools are available:

1. git
2. rsync

Install can be handled by running either:

```shell
sudo dnf install -y git rsync
```

or 

```shell
rpm-ostree upgrade --install=git --install=rsync
```

## Set Up

To set up this repository in home, run the following commands:

```shell
rm -rf "$HOME/.tmp/git-home-temp"
mkdir -p "$HOME/.tmp/git-home-temp"
git clone https://github.com/rmgrimm/home-git.git -b env/baremetal/fedora --depth 1 --no-tags --recurse-submodules --shallow-submodules --remote-submodules "$HOME/.tmp/git-home-temp"
rsync -av "$HOME/.tmp/git-home-temp/" "$HOME/"
rm -rf "$HOME/.tmp/git-home-temp"
rmdir --ignore-fail-on-non-empty "$HOME/.tmp/"

"$HOME/.opt/rmg-bash-init/install.sh"
```

Optionally, the git remote can be set to use SSH and email set to the GitHub
public email:

```shell
git config user.email "rmgrimm@users.noreply.github.com"
git remote set-url origin git@github.com:rmgrimm/home-git.git
git remote set-url --push origin git@github.com:rmgrimm/home-git.git
```
