#!/bin/bash

sudo docker exec -it postmap /etc/postfix/virtual_alias.db
sudo docker exec -it postmap /etc/postfix/virtual_alias_regexp.db
sudo docker exec -it postmap /etc/postfix/transport_maps.db
sudo docker exec -it postmap /etc/postfix/transport_maps_regexp.db
sudo docker exec -it postmap /etc/postfix/sasl_passwd.db
sudo docker restart postfix

sudo docker exec -it postfix postconf -n