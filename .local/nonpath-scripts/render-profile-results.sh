#!/bin/bash

# Based on http://stackoverflow.com/a/20855353

paste <(
    while read times; do
        [ -z "$last" ] && last=${times//.} && first=${times//.}
        crt=000000000$((${times//.}-10#0$last))
        ctot=000000000$((${times//.}-10#0$first))
        printf "%12.9f %12.9f\n" \
               ${crt:0:${#crt}-9}.${crt:${#crt}-9} \
               ${ctot:0:${#ctot}-9}.${ctot:${#ctot}-9}
        last=${times//.}
    done < /tmp/profiled-bash.$1.times
) /tmp/profiled-bash.$1.log
