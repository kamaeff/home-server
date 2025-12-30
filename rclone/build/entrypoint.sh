#!/bin/sh
set -e

# https://stackoverflow.com/questions/27771781/how-can-i-access-docker-set-environment-variables-from-a-cron-job
printenv >> /etc/environment

# setting default config if config is not set
if ! [ -f "/config/rclone/rclone.conf" ]; then
    cp "/rclone.conf.example" "/config/rclone/rclone.conf"
fi

# allowing to call rclone config
if [ "$1" == "config" ]; then
    rclone "$@"
    exit "$?"
fi

SRC_CRONTAB=/crontab
DST_CRONTAB=/etc/crontabs/root

function crontab_is_up_to_date {
    local valid_crontab_stat='600:0:0'
    local crontab_stat="$(stat -c "%a:%u:%g" "${DST_CRONTAB}")"

    # file contents are identical and permissions/owner/group are correct
    cmp "${SRC_CRONTAB}" "${DST_CRONTAB}" && [ "${crontab_stat}" -eq "${valid_crontab_stat}" ]
}

if ! crontab_is_up_to_date; then
    echo "crontab isn't up to date"
    echo "copying '${SRC_CRONTAB}' into '${DST_CRONTAB}'"
    crontab "${SRC_CRONTAB}"
fi

echo "crontab contents:"
crontab -l
echo
echo "cron scripts:"
ls -1 /cron-scripts

for script_name in /cron-scripts/*.sh; do
    echo "running ${script_name}"
    CRON_SCRIPT_RUN_AT_STARTUP=1 /bin/sh "${script_name}"
done

echo "starting crond with [-l]og level 2 in [-f]oreground"
exec crond -l 2 -f
