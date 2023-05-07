#!/bin/sh

echo "setup directories"

mkdir -p /data/docroot/app/config/
mkdir -p /config/
mkdir -p /cache/
mkdir -p /logs/

cp /usr/local/etc/mautic/paths_local.php /data/docroot/app/config/

exit 0