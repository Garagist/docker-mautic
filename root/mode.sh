#!/bin/sh

MAUTIC_CONTEXT="${MAUTIC_CONTEXT:-Development}"

if [ $MAUTIC_CONTEXT == 'Development' ]; then
  fixuid "$@"
else
  echo "fixuid: skipped because Production MAUTIC_CONTEXT"

  DIR=/docker-entrypoint.d

  if [ -d "$DIR" ]; then
    for SCRIPT in $DIR/*; do
      if [ -f $SCRIPT -a -x $SCRIPT ]; then
        echo
        echo "Run $SCRIPT ..."
        $SCRIPT
      fi
    done
  fi

  exec "$@"
fi
