#!/bin/sh

echo "setup config"

mkdir -p /data/docroot/app/config/

cp /usr/local/etc/mautic/paths_local.php /data/docroot/app/config/

exit 0