#!/bin/sh

MAUTIC_RUN_MIGRATION="${MAUTIC_RUN_MIGRATION:-'true'}"

if [ $MAUTIC_RUN_MIGRATION == 'true' ]; then
    echo -e "run doctine migration\n"
    cd /data
    php bin/console doctrine:migrations:migrate --no-interaction
else
    echo -e "doctine migration skipped >>\n"
fi;

exit 0