#!/bin/sh

set -e

rm -rf /static/*

wget -O /tmp/aria-ng.zip https://github.com/mayswind/AriaNg/releases/download/1.3.13/AriaNg-1.3.13.zip

unzip /tmp/aria-ng.zip -d /static/aria-ng
