#!/bin/sh
source /usr/local/sbin/checks.sh
echo "setup caddy"

ssl_enabled=$(check_true "$MAUTIC_SSL_ENABLED")

if [[ "${ssl_enabled}" == "true" ]] && [[  -n "$MAUTIC_TLS_EMAIL" ]]; then
  sed -e "s#TLS#tls ${MAUTIC_TLS_EMAIL}#g" -e "s#SCHEMA#${MAUTIC_DOMAIN}#g" /usr/local/etc/caddy/Caddyfile > /home/docker/Caddyfile
  echo "tls enabled"
else
  sed -e "s#TLS##g" -e "s#SCHEMA#http://${MAUTIC_DOMAIN}#g" /usr/local/etc/caddy/Caddyfile > /home/docker/Caddyfile
  echo "tls disabled"
fi

exit 0