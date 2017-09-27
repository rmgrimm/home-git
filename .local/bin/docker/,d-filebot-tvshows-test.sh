#!/bin/sh

. .docker-init.sh

if [ "$#" -gt 0 ]; then
  DATA=$1
  shift
else
  echo >&2 "Usage: `basename $0` <data directory> [media directory] [filebot options]"
  exit 1
fi

if [ -d "$1" ]; then
  VOLUME=$1
  shift
else
  VOLUME=$PWD
fi

__rmg_d_run rednoah/filebot rednoah/filebot - \
            --rmg-multi \
            -v "${VOLUME}:/volume1" \
            -v "${DATA}:/data" \
            --rm \
            -- \
            -rename \
            --db TheTVDB \
            --action test \
            --format "/volume1/filebot-output/{n.colon(' - ').replaceAll(/[\\\`´‘’ʻ]/, /'/).replaceAll(/[!?.]+$/)}/{episode.special ? 'Specials' : 'Season '+s.pad(2)}/{n.colon(' - ').replaceAll(/[\\\`´‘’ʻ]/, /'/).replaceAll(/[!?.]+$/)} - {episode.special ? 'S00E'+special.pad(2) : s00e00} - {t.colon(' - ').replaceAll(/[\\\`´‘’ʻ]/, /'/).replaceAll(/[!?.]+$/).replacePart(', Part \\\$1')}{'.'+lang}" \
            -non-strict \
            -r \
            /volume1 \
            "$@"
