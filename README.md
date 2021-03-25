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

## Optional

The following items may provide a better experience:

1. dbus-launch
2. lxterminal

Install with:

```shell
sudo apt install -y dbus-launch lxterminal
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

"$HOME/.opt/rmg-bash-init/install.sh"
```

Optionally, the git remote can be set to use SSH and email set to the GitHub
public email:

```shell
git config user.email "rmgrimm@users.noreply.github.com"
git remote set-url origin git@github.com:rmgrimm/home-git.git
git remote set-url --push origin git@github.com:rmgrimm/home-git.git
```

## Other notes

### Audio on CloudReady

In order to get audio going over HDMI on an old GeForce GT 610, I had to follow
the basic steps from [a post in the CloudReady community][audio-fix-post]:

1. Start with opening a ChromeOS terminal `CTRL+ALT+T`.
2. Type `shell` to enter a "dev-mode" Bash shell
3. Use `alsamixer` to unmute S/PDIF on the HDMI card (`F6` or `S` to switch
   to the HDMI soundcard)
4. Exit alsamixer and enter the following commands in the shell:

```shell
sudo mkdir -p /var/lib/alsa
sudo alsactl store
```

_Note: It may also help to add the crouton user to the `hwaudio` group as well:_

```shell
sudo adduser robert hwaudio
```

[audio-fix-post]: https://neverware.zendesk.com/hc/en-us/community/posts/360001306348/comments/360002441773
