#! /bin/sh

set -e

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
export PATH

# kill saslauthd if running
killall -q -SIGSTOP saslauthd

# run saslauthd
/usr/sbin/saslauthd -a sasldb

ret=$?
sleep 1
exit $ret