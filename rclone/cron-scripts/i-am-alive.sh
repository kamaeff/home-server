#!/bin/sh

curl -m 10 --retry 5 "${HEALTHCHECKS_URL_I_AM_ALIVE}"
