# Debian in Crouton chroot for ChromeOS/CloudReady

Home directory settings for use with Crouton chroots running Debian (and
Debian-based) distrobutions on ChromeOS or [CloudReady][cloudready-homepage].

[cloudready-homepage]: https://www.neverware.com/freedownload

## Requirements

Prior to setting up, ensure that the following tools are available:

1. rsync

Install can be handled by running:

```shell
sudo apt install -y rsync
```

## Set Up

To set up this repository in home, run the following commands:

```shell
rm -rf "$HOME/.tmp/git-home-temp"
mkdir -p "$HOME/.tmp/git-home-temp"
git clone https://github.com/rmgrimm/home-git.git -b env/crouton/debian --depth 1 --no-tags --recurse-submodules --shallow-submodules --remote-submodules "$HOME/.tmp/git-home-temp"
rsync -av "$HOME/.tmp/git-home-temp/" "$HOME/"
rm -rf "$HOME/.tmp/git-home-temp"
rmdir --ignore-fail-on-non-empty "$HOME/.tmp/"
```

Optionally, the git remote can be set to use SSH and email set to the GitHub
public email:

```shell
git config user.email "rmgrimm@users.noreply.github.com"
git remote set-url origin git@github.com:rmgrimm/home-git.git
git remote set-url --push origin git@github.com:rmgrimm/home-git.git
```
