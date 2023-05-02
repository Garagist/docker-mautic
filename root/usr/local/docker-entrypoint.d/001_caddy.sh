#!/bin/sh

echo "setup caddy"

schema="http"
if [[ "${MAUTIC_SSL_ENABLED}" == "true" ]] && [[  -n "$MAUTIC_TLS_EMAIL" ]]; then
  sed -e "s/\$TLS/tls ${MAUTIC_TLS_EMAIL}/g" -e "s/\$HTTP_SCHEMA/https/g" /usr/local/etc/caddy/Caddyfile > /home/docker/Caddyfile
else
  sed -e "s/\$TLS/ /g" -e "s/\$HTTP_SCHEMA/http/g" /usr/local/etc/caddy/Caddyfile > /home/docker/Caddyfile
fi

exit 0