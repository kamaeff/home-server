#!/bin/sh

# don't run at startup
if [ ${CRON_SCRIPT_RUN_AT_STARTUP} -eq 1 ]; then
    echo "borg compact only runs from CRON. Currently running at startup. Exitting..."
    exit
fi

borg compact -v /backups/home-server
