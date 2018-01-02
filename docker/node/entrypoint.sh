#!/bin/sh

uid=$(stat -c %u /srv)
gid=$(stat -c %g /srv)

if [ $uid == 0 ] && [ $gid == 0 ]; then
    if [ $# -eq 0 ]; then
        sleep 9999d
    else
        exec "$@"
    fi
fi

sed -i -r "s/node:x:1000:1000:Linux/node:x:100:100:Linux/g" /etc/passwd

sed -i -r "s/foo:x:\d+:\d+:/foo:x:$uid:$gid:/g" /etc/passwd
sed -i -r "s/bar:x:\d+:/bar:x:$gid:/g" /etc/group
chown foo /home

if [ $# -eq 0 ]; then
    sleep 9999d
else
    exec su-exec foo "$@"
fi
