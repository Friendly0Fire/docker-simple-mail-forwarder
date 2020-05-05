#!/bin/bash

if [ ! -f /entrypoint.sh ]
then
    >&2 echo ">> you're not inside a valid docker container"
    exit 1
fi

if [ ! -f /etc/postfix/db/initialized ]
then
    cp /etc/postfix/db.dist/* /etc/postfix/db/

    touch /etc/postfix/db/initialized
    chown root:root /etc/postfix/db/initialized
    chmod 700 /etc/postfix/db/initialized
fi

if [ ! -f /etc/postfix/initialized ]
then
    sed -i "s|#__DOCKER_HOSTNAME__|$HOSTNAME|" /etc/postfix/main.cf
    sed -i "s|#__DOCKER_TLS_CHAINS_FILE__|$TLS_CHAINS_FILE|" /etc/postfix/main.cf
    sed -i "s|#__DOCKER_CERTS__|$CERT_FILES|" /etc/postfix/main.cf

    cat /dev/null > /etc/postfix/aliases && newaliases

    touch /etc/postfix/initialized
    chown root:root /etc/postfix/initialized
    chmod 700 /etc/postfix/initialized

    rm -rf /etc/postfix/db.dist
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
