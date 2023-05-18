#!/bin/sh
source /usr/local/sbin/checks.sh

MAUTIC_RUN_MIGRATION=$(check_true "$MAUTIC_RUN_MIGRATION")

if [ $MAUTIC_RUN_MIGRATION == 'true' ]; then
    echo -e "run doctrine migration\n"
    cd /data
    php bin/console doctrine:migrations:migrate --no-interaction
else
    echo -e "doctine migration skipped >>\n"
fi;

exit 0
