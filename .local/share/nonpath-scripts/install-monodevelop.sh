#!/bin/bash

if ! sudo -v; then
    echo "sudo failed; aborting..."
    exit 1
fi

sudo aptitude install \
    monodevelop \
    monodevelop-nunit \
    monodevelop-versioncontrol \
    monodevelop-database
