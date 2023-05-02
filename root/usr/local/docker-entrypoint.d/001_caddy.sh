#!/bin/sh

echo "setup caddy"

if test "$(echo "$MAUTIC_SSL_ENABLED" | tr '[:upper:]' '[:lower:]')" = "true"; then
  ssl_enabled=true
else
  ssl_enabled=false
fi

if [[ "${ssl_enabled}" == "true" ]] && [[  -n "$MAUTIC_TLS_EMAIL" ]]; then
  sed -e "s/\$TLS/tls ${MAUTIC_TLS_EMAIL}/g" -e "s/\$HTTP_SCHEMA/${MAUTIC_DOMAIN}/g" /usr/local/etc/caddy/Caddyfile > /home/docker/Caddyfile
else
  sed -e "s/\$TLS/ /g" -e "s/\$HTTP_SCHEMA/${MAUTIC_DOMAIN}/g" /usr/local/etc/caddy/Caddyfile > /home/docker/Caddyfile
fi

exit 0