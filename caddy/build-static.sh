#!/bin/sh

set -e

rm -rf /static/*

wget -O /tmp/aria-ng.zip https://github.com/mayswind/AriaNg/releases/download/1.3.13/AriaNg-1.3.13.zip
unzip /tmp/aria-ng.zip -d /static/aria-ng-tmp
# only do atomic mv on success of previous operations
mv /static/aria-ng-tmp /static/aria-ng


git clone --depth=1 https://github.com/kamaeff/ps4-jb-webkit.git /tmp/ps4-jb-webkit
mv /tmp/ps4-jb-webkit/public /static/ps4-jb-webkit-tmp
# only do atomic mv on success of previous operations
mv /static/ps4-jb-webkit-tmp /static/ps4-jb-webkit
