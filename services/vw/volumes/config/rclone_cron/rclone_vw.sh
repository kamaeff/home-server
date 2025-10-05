#!/bin/sh

rclone copy /vaultwarden/ union:vaultwarden
if [ "$?" -eq 0 ]; then
    curl -m 10 --retry 5 "${HEALTHCHECKS_URL_RCLONE_VW_BACKUP}"
fi
