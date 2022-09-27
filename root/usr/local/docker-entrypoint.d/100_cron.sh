#!/bin/sh

#set log level. Most verbose:0, default:8
MAUTIC_CRON_LOG_LEVEL="${MAUTIC_CRON_LOG_LEVEL:-8}"

if [ $MAUTIC_CRON_RUN_JOBS == 'true' ]; then
    crond -b -c /data/cron/ -L /data/cron.log -l $MAUTIC_CRON_LOG_LEVEL
else
    echo "Mautic cron jobs disabled"
fi;

exit 0