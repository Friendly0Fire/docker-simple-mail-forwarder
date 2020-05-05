#!/bin/bash

sudo docker exec -it postmap /etc/postfix/db/virtual_alias.db
sudo docker exec -it postmap /etc/postfix/db/virtual_alias_regexp.db
sudo docker exec -it postmap /etc/postfix/db/transport_maps.db
sudo docker exec -it postmap /etc/postfix/db/transport_maps_regexp.db
sudo docker exec -it postmap /etc/postfix/db/sasl_passwd.db
sudo docker restart postfix

sudo docker exec -it postfix postconf -n