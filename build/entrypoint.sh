#!/bin/bash

echo ">> Chdir to /app..."
cd /app

if [ ! -f /entrypoint.sh ]
then
    >&2 echo ">> you're not inside a valid docker container"
    exit 1
fi

if [ ! -f /etc/postfix/main.cf ]
then
    cp /etc/dist/main.cf /etc/postfix/main.cf
    sed -i "s/#__DOCKER_HOSTNAME__/$HOSTNAME" /etc/postfix/main.cf
    sed -i "s/#__DOCKER_TLS_CHAINS_FILE__/$TLS_CHAINS_FILE" /etc/postfix/main.cf
    sed -i "s/#__DOCKER_RELAY_HOST__/$RELAY_HOST" /etc/postfix/main.cf

    touch /etc/postfix/virtual_alias.db
    touch /etc/postfix/virtual_alias_regexp.db
    touch /etc/postfix/transport_maps.db
    touch /etc/postfix/transport_maps_regexp.db
    touch /etc/postfix/sasl_passwd.db

    chown root:root /etc/postfix/sasl_passwd.db
    chmod 700 /etc/postfix/sasl_passwd.db
fi

if [ ! -f /etc/postfix/master.cf ]
then
    cp /etc/dist/main.cf /etc/postfix/master.cf
fi

if [ ! -f /etc/syslog-ng/syslog-ng.conf ]
then
    cp /etc/dist/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
fi

postfix start

# Init
echo ">> Init System for Servicing..."
exec /init

# ERROR: exec returned?!
ret=$?
echo ">> Exec ERROR: $ret"
sleep 7
exit $ret
