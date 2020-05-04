#!/bin/bash

if [ ! -f ./config.sh ]
then
    read -p "No configuration set, would you like to copy the default file to edit it? (Y/n)" -n 1 -r
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then
        cp ./config.dist.sh config.sh
    fi

    exit 1
fi

source config.sh

docker rm --force $DOCKER_CONTAINER_NAME

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker build -t $DOCKER_IMAGE_NAME $DIR/build/.

docker run \
        --name $DOCKER_CONTAINER_NAME \
        -p 25:25 \
        -e HOSTNAME=$DOCKER_HOSTNAME \
        -e RELAY_HOST=$DOCKER_RELAY_HOST \
        -v $DOCKER_TLS_CHAINS_FILE:/etc/ssl/chains.pem:ro \
        -v $DIR/data/postfix:/etc/postfix \
        -v $DIR/data/syslog-ng:/etc/syslog-ng \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        -d \
        --restart=unless-stopped \
        $DOCKER_IMAGE_NAME

docker inspect -f '{{ .Mounts }}' $DOCKER_CONTAINER_NAME