#!/bin/sh

MAUTIC_RUN_MIGRAION="${MAUTIC_RUN_MIGRAION:-'true'}"

if [ $MAUTIC_RUN_MIGRAION == 'true' ]; then
    echo -e "Startup: run doctine migration\n"
    cd /data
    php bin/console doctrine:migrations:migrate --no-interaction
else
    echo -e "Startup: doctine migration skipped >>\n"
fi;

exit 0