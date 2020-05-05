#!/bin/bash

if [ ! -f ./config.sh ]
then
    read -p "No configuration set, would you like to copy the default file to edit it? (Y/n) " -n 1 -r
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then
        cp ./config.dist.sh config.sh
    fi
    echo
    exit 1
fi

source config.sh

DOCKER_BIND_MOUNTS=""
DOCKER_CHAIN_FILES=""
CERT_ID=0
for certpath in ${DOCKER_CERT_FILES//;/ } ; do
    certfile="$(basename -- $certpath)"
    DOCKER_BIND_MOUNTS="${DOCKER_BIND_MOUNTS} -v ${certpath}:/etc/certs/cert${CERT_ID}.pem:ro"
    DOCKER_CHAIN_FILES="${DOCKER_CHAIN_FILES}, /etc/certs/cert${CERT_ID}.pem"

    ((CERT_ID+=1))
done
DOCKER_CHAIN_FILES="${DOCKER_CHAIN_FILES:2}"

docker rm --force $DOCKER_CONTAINER_NAME

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker build -t $DOCKER_IMAGE_NAME $DIR/build/.

docker run \
        --name $DOCKER_CONTAINER_NAME \
        -p 25:25 \
        -e HOSTNAME=$DOCKER_HOSTNAME \
        -e RELAY_HOST=$DOCKER_RELAY_HOST \
        -e CERT_FILES="$DOCKER_CHAIN_FILES" \
        $DOCKER_BIND_MOUNTS \
        -v $DIR/data/:/etc/postfix/db/ \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        -d \
        --restart=unless-stopped \
        $DOCKER_IMAGE_NAME

docker inspect -f '{{ .Mounts }}' $DOCKER_CONTAINER_NAME