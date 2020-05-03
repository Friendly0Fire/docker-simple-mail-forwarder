#!/bin/bash

echo ">> Chdir to /app..."
cd /app

[ -e BUILD.env ] && source BUILD.env

if [ ! -f /entrypoint.sh ]
then
    >&2 echo ">> you're not inside a valid docker container"
    exit 1;
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
