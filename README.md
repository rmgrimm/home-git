# Home Directory Settings

This repository holds common settings I like to have version-controlled or
shared across systems. Different common environments are held in separate
branches of this repository.

## Available Branches

The available branches include:

 * [env/crostini/fedora][crostini-fedora-branch] - for use with Fedora on
   ChromeOS's Crostini linux container
 * [env/crouton/debian][crouton-debian-branch] - for use with Debian (and
   Debian-based) in a chroot on ChromeOS or CloudReady
 * [env/old][old-branch] - the branch containing all my old configs before
   reorganization

## Using an available branch

Each branch will include environment-specific instructions for how to set up
the home directory with the settings contained in the repository and then
start tracking changes.

## Adding a new environment

To add a new environment, check out the [env/new-env-base][new-env-base-branch]
branch and create a new orphan branch. For example, with the repository
already checked out, the following commands could be used:

```shell
git checkout env/new-env-base
git checkout --orphan env/new-branch-name
```

After this is complete, adjust as necessary, update README.md, commit, and
push.

[crostini-fedora-branch]: https://github.com/rmgrimm/home-git/tree/env/crostini/fedora
[new-env-base-branch]: https://github.com/rmgrimm/home-git/tree/env/new-env-base
[old-branch]: https://github.com/rmgrimm/home-git/tree/env/old
