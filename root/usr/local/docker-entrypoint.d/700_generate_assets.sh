#!/bin/sh
source /usr/local/sbin/checks.sh

php bin/console mautic:assets:generate

exit 0