#!/bin/sh

set -e

# this setup script assumes it is run under Raspberry Pi OS

DIRNAME="$(dirname "$(readlink -f "${0}")")"
cd "${DIRNAME}"

if ! [ -f ./.env ]; then
    cp .env.example ./.env
fi
nano ./.env

# populate environment
. ./.env

docker compose build --pull
docker compoe pull

docker compose run --rm rclone config

./services/vw/setup.sh

crontab='0 * * * * '"root curl -m 10 --retry 5 \"${HEALTHCHECKS_URL_I_AM_ALIVE}\""
sudo sh -c "echo '${crontab}' > /etc/cron.d/healthcheck"


echo "setup SUCCESS"
