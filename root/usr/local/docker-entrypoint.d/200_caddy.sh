#!/bin/sh
source /usr/local/sbin/checks.sh
echo "setup caddy"

ssl_enabled=$(check_true "$MAUTIC_SSL_ENABLED")
if [[ "${ssl_enabled}" == "true" ]] && [[  -n "$MAUTIC_TLS_EMAIL" ]]; then
  SCHEMA="https://"
  TLS="tls ${MAUTIC_TLS_EMAIL}"
  echo "tls enabled"
else
  TLS=""
  SCHEMA="http://"
  echo "tls disabled"
fi

if [ -z "$MAUTIC_DOMAIN" ]; then
  DOMAINS="http://"
else
  DOMAINS=""
  for item in $MAUTIC_DOMAIN
  do
      if [ -z "$DOMAINS" ]
      then
        DOMAINS="${SCHEMA}${item}"
      else
        DOMAINS="$DOMAINS, ${SCHEMA}${item}"
      fi
  done
fi
echo "Domains ${DOMAINS}"

if [ "$MAUTIC_CONTEXT" = "Development" ]
  then
    echo "development context"
  else
    echo "production context"
fi

sed -e "s#TLS#${TLS}#g" -e "s#DOMAINS#${DOMAINS}#g" /usr/local/sites-enabled/default.conf > /mautic/Caddyfile
echo "Environment: ${MAUTIC_CONTEXT}"
exit 0
