#!/bin/bash

docker rm --force postfix

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker build -t simple-postfix $DIR/build/.

docker run \
        --name postfix \
        -p 25:25 \
        -v $DIR/data/postfix:/etc/postfix \
        -v $DIR/data/syslog:/etc/syslog \
        -v /etc/letsencrypt:/etc/postfix/certs:ro \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        -d \
        --restart=unless-stopped \
        simple-postfix

docker inspect -f '{{ .Mounts }}' postfix