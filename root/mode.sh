#!/bin/sh

MAUTIC_CONTEXT="${MAUTIC_CONTEXT:-Development}"

#handle fixuid for development environment
if [ $MAUTIC_CONTEXT == 'Development' ]; then
  fixuid
else
  echo "fixuid: skipped because MAUTIC_CONTEXT != Development"
fi

#handle default docker-entrypoint.d scripts
DIR=/usr/local/docker-entrypoint.d
if [ -d "$DIR" ]; then
  for SCRIPT in $DIR/*; do
    if [ -f $SCRIPT -a -x $SCRIPT ]; then
      echo "Run mautic script: $SCRIPT ..."
      $SCRIPT
    fi
  done
fi

#handle docker-entrypoint.d scripts
DIR=/data/docker-entrypoint.d
if [ -d "$DIR" ]; then
  for SCRIPT in $DIR/*; do
    if [ -f $SCRIPT -a -x $SCRIPT ]; then
      echo "Run custom script: $SCRIPT ..."
      $SCRIPT
    fi
  done
fi

exec "$@"

