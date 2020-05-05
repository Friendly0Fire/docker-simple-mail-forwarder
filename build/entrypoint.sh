#!/bin/bash

if [ ! -f /entrypoint.sh ]
then
    >&2 echo ">> you're not inside a valid docker container"
    exit 1
fi

if [ ! -f /etc/postfix/initialized ]
then
    ESCAPED_RELAY_HOST=$(echo $RELAY_HOST | sed -e 's/[]\/$*.^[]/\\&/g');

    sed -i "s|#__DOCKER_HOSTNAME__|$HOSTNAME|" /etc/postfix/main.cf
    sed -i "s|#__DOCKER_TLS_CHAINS_FILE__|$TLS_CHAINS_FILE|" /etc/postfix/main.cf
    sed -i "s|#__DOCKER_RELAY_HOST__|$ESCAPED_RELAY_HOST|" /etc/postfix/main.cf
    sed -i "s|#__DOCKER_CERTS__|$CERT_FILES|" /etc/postfix/main.cf

    touch /etc/postfix/db/virtual_alias.db
    touch /etc/postfix/db/virtual_alias_regexp.db
    touch /etc/postfix/db/transport_maps.db
    touch /etc/postfix/db/transport_maps_regexp.db
    touch /etc/postfix/db/sasl_passwd.db

    chown root:root /etc/postfix/db/sasl_passwd.db
    chmod 700 /etc/postfix/db/sasl_passwd.db

    cat /dev/null > /etc/postfix/aliases && newaliases

    touch /etc/postfix/initialized
fi

postfix set-permissions

postfix start

# Init
echo ">> Init System for Servicing..."
exec /init

# ERROR: exec returned?!
ret=$?
echo ">> Exec ERROR: $ret"
sleep 7
exit $ret
