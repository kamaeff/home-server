#!/bin/sh
set -e

# https://stackoverflow.com/questions/27771781/how-can-i-access-docker-set-environment-variables-from-a-cron-job
printenv >> /etc/environment

# setting default config if config is unset
if ! [ -f "/config/rclone/rclone.conf" ]; then
    cp "/config/rclone_example/rclone.conf" "/config/rclone/rclone.conf"
fi


# allowing to call rclone config
if [ "$1" == "config" ]; then
    rclone "$@"
    exit "$?"
fi


for directory in /bin/cron_scripts/*; do
    for script_name in "${directory}/"*.sh; do
        # launching script now
        script_file="$(readlink -f "${script_name}")"
        echo "execuing ${script_file}"
        chmod +x "${script_file}"
        "${script_file}"

        # adding script to crontab with corresponding crontime
        crontime_file="${script_file%.*}".crontime
        crontime="$(grep -v '^#' "${crontime_file}" | tr -d '\n')"
        
        crontab_="${crontime} ${script_file} >/proc/1/fd/1 2>/proc/1/fd/2"
        echo "adding crontab:\n${crontab_}"
        echo "${crontab_}" | crontab
    done
done

echo "current crontab contents:"
crontab -l

# starting crond with [-l]og level 2 in [-f]oreground
exec crond -l 2 -f
