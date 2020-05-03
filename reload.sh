#!/bin/bash

sudo docker restart postfix
sudo docker exec -it postfix postconf -n