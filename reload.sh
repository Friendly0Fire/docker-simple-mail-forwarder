#!/bin/bash

source config.sh

sudo docker exec -it $DOCKER_CONTAINER_NAME postmap /etc/postfix/db/virtual_alias
sudo docker exec -it $DOCKER_CONTAINER_NAME postmap /etc/postfix/db/virtual_alias_regexp
sudo docker exec -it $DOCKER_CONTAINER_NAME postmap /etc/postfix/db/transport_maps
sudo docker exec -it $DOCKER_CONTAINER_NAME postmap /etc/postfix/db/transport_maps_regexp
sudo docker exec -it $DOCKER_CONTAINER_NAME postmap /etc/postfix/db/sasl_passwd
sudo docker restart $DOCKER_CONTAINER_NAME