#!/bin/sh

#set log level. Most verbose:0, default:8
MAUTIC_CRON_LOG_LEVEL="${MAUTIC_CRON_LOG_LEVEL:-8}"

if [ $MAUTIC_CRON_RUN_JOBS == 'true' ]; then
    mkdir -p /data/cron/
    mkdir -p /data/log/
    cp /usr/local/etc/mautic/mautic.crontab /data/cron/docker
    crond -b -c /data/cron/ -L /log/crond.log -l $MAUTIC_CRON_LOG_LEVEL
else
    echo -e "cron jobs disabled\n"
fi;

exit 0