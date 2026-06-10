#!/bin/sh

if [ "$*" = "import-json" ]; then
    zstd --stdout -d /import/*.jsonl.zst | java -jar /opt/app/photon.jar import -j 2 -reverse-only -import-file - -languages en,ru,uk,hy
elif [ "$*" = "serve" ]; then
    exec java -jar /opt/app/photon.jar serve -j 2 -listen-ip 0.0.0.0 -reverse-only
elif [ "$1" = "photon" ]; then
    shift
    exec java -jar /opt/app/photon.jar "$@"
else
    exec "$@"
fi
