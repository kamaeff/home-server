#!/bin/sh

SESSION_FILE=/aria2-data/aria2.session

if [ ! -f "${SESSION_FILE}" ]; then
    touch "${SESSION_FILE}"
fi

exec /usr/bin/aria2c \
  --rpc-listen-all \
  --dir=/downloads \
  --enable-rpc \
  --rpc-secret="${ARIA2_RPC_SECRET}" \
  --input-file="${SESSION_FILE}" \
  --save-session="${SESSION_FILE}" \
  --continue
