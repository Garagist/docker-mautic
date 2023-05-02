#!/bin/sh

MAUTIC_RUN_COMPOSER_INSTALL="${MAUTIC_RUN_COMPOSER_INSTALL:-'true'}"

if [ $MAUTIC_RUN_COMPOSER_INSTALL == 'true' ]; then
    if [ ! -f /data/composer.json ]; then
        echo -e "no composer file found! Skip >>\n"
    else
        echo -e "run composer install\n"
        cd /data/
        composer install --no-interaction --no-ansi --optimize-autoloader --no-progress --prefer-dist
    fi
else
    echo -e "composer install disabled\n"
fi;

exit 0