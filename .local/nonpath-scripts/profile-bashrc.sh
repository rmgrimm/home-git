#!/bin/bash

# This should be executed to profile the noninteractive path, and sourced
# to profile the interactive path.

exec 3>&2 2> >( tee /tmp/profiled-bash.$$.log |
                      sed -u 's/^.*$/now/' |
                      date -f - +%s.%N > /tmp/profiled-bash.$$.times)
set -x

. "$HOME/.bashrc"

set +x
exec 2>&3 3>&-

echo "Results saved for PID $$"
