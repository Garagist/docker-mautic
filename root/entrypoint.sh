#!/bin/sh

php-fpm -D -R -y /usr/local/etc/php-fpm.conf

# A place to pipe log
( touch "/tmp/php-fpm.log"; tail -qF -n 0 /tmp/php-fpm.log | sed 's/WARNING: \[pool www\] child [0-9]* said into stdout: \"\(.*\)\"$/\1/' 1>&2 ) &

caddy run --config /mautic/Caddyfile