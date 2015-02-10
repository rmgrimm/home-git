#!/bin/bash

add_repos () {
    exit 0
}

install_packages () {
    sudo aptitude install -y \
        apt-file             `: to find where files come from` \
        bzr \
        cpu-checker \
        curl \
        emacs24 emacs24-el emacs24-common-non-dfsg \
        etckeeper            `: track changes to /etc` \
        fail2ban \
        git git-doc \
        git-bzr git-cvs git-svn \
        htop \
        libnss-myhostname \
        lrzip                `: high compression rate for large files` \
        lynx-cur \
        make \
        mercurial \
        mosh \
        openssh-server \
        p7zip-full p7zip-rar \
        sqlite3 \
        texinfo \
        tmux \
        tree                 `: when ls is simply not enough` \
        unison \
        zile \
        \
        || exit 1

    exit 0
}

if [ x"$1" = x"" ]; then
    add_repos || exit 1
    install_packages || exit 1
    exit 0
fi

case "$1" in
    repos) add_repos; exit $?; ;;
    packages) install_packages; exit $? ;;
    *) echo "Unrecognized command $1..."; exit 1 ;;
esac
