#!/bin/bash

source config.sh

echo "Refreshing all maps..."

sudo docker exec -it $DOCKER_CONTAINER_NAME postmap /etc/postfix/db/virtual_alias
sudo docker exec -it $DOCKER_CONTAINER_NAME postmap /etc/postfix/db/virtual_alias_regexp
sudo docker exec -it $DOCKER_CONTAINER_NAME postmap /etc/postfix/db/transport_maps
sudo docker exec -it $DOCKER_CONTAINER_NAME postmap /etc/postfix/db/transport_maps_regexp
sudo docker exec -it $DOCKER_CONTAINER_NAME postmap /etc/postfix/db/sasl_passwd

sudo docker exec -it $DOCKER_CONTAINER_NAME postfix reload

echo "Here is the current configuration:"

sudo docker exec -it $DOCKER_CONTAINER_NAME postconf -n | sed 's/^/    /'