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


echo "current crontab contents:"
crontab -l
echo
echo "cron scripts:"
ls -1 /cron-scripts

for script_name in "${directory}/"*.sh; do
    echo "running ${script_name}"
    CRON_SCRIPT_RUN_AT_STARTUP=1 /bin/sh "${script_name}"
done

echo "starting crond with [-l]og level 2 in [-f]oreground"
exec crond -l 2 -f
