#!/bin/sh

set -e

borg create -v --stats '/backups/home-server::app-data-{utcnow}' \
    --exclude='/app-data/vw' \
    --exclude='/app-data/borg/cache' \
    --exclude='/app-data/transmission' \
    --exclude='/app-data/picard' \
    --exclude='/app-data/slskd' \
    --exclude='/app-data/caddy' \
    --exclude='/app-data/copyparty' \
    --exclude='/app-data/navidrome-octo-fiesta' \
    --exclude='/app-data/immich/model-cache' \
    --exclude='/app-data/immich/postgres' \
    --exclude='/app-data/immich/library/encoded-video' \
    --exclude='/app-data/immich/library/thumbs' \
    --exclude='/app-data/navidrome/cache' \
    --exclude='/app-data/explo' \
    -- /app-data

[ -n "${FILESHARE_SUBPATH_1}" ]
[ -n "${FILESHARE_SUBPATH_2}" ]

borg create -v --stats '/backups/home-server::fileshare-{utcnow}' \
    --exclude="/fileshare/${FILESHARE_SUBPATH_1}/downloads" \
    --exclude="/fileshare/${FILESHARE_SUBPATH_1}/music/staging" \
    --exclude="/fileshare/${FILESHARE_SUBPATH_1}/music/explore" \
    --exclude="/fileshare/${FILESHARE_SUBPATH_2}/ФИЛЬМЫ И СЕРИАЛЫ/" \
    -- /fileshare


borg prune -v --stats --list --keep-daily=7 --keep-weekly=4 --keep-monthly=3 --glob-archives='app-data-*' /backups/home-server
borg prune -v --stats --list --keep-daily=7 --keep-weekly=4 --keep-monthly=3 --glob-archives='fileshare-*' /backups/home-server

curl -m 10 --retry 5 "${HEALTHCHECKS_URL_BORG_LOCAL_BACKUP}"
