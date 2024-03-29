FROM golang:latest AS builder

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
    mkdir /build && cd /build && \
    xcaddy build \
        --with github.com/abiosoft/caddy-exec

FROM alpine:latest as caddy

ARG USER="docker"
ARG USERID="1000"
ARG GROUP="docker"
ARG GROUPID="1000"

# Install Caddy
COPY --from=builder /build/caddy /usr/bin/caddy

RUN apk --no-cache add ca-certificates mailcap && \
    addgroup -g $GROUPID $GROUP && \
    adduser -u $USERID -G $GROUP -h /home/$USER -s /bin/sh -D $USER && \
    chmod 755 /usr/bin/caddy

USER docker:docker


FROM php:8.0-fpm-alpine AS worker

LABEL vendor="Garagist"
LABEL maintainer="David Spiola"

ARG USER="docker"
ARG USERID="1000"
ARG GROUP="docker"
ARG GROUPID="1000"

# Copy configuration
COPY root / 

# Docker USER
RUN addgroup -g $GROUPID $GROUP \
    && adduser -u $USERID -G $GROUP -h /home/$USER -s /bin/sh -D $USER

# Install fixuid
RUN /usr/local/sbin/install-fixuid.sh

# Custom PHP requirements
RUN set -x \
    && cat /etc/os-release \
    && mkdir -p /data \
    && apk --update add curl libcap git dcron libcap \
    && curl -sSLf -o /usr/local/bin/install-php-extensions \
           https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
       chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions \
      gd \
      gmp \
      pdo_mysql \
      pdo_pgsql \
      opcache \
      exif \
      bcmath \
      mcrypt \
      zip \
      bz2 \
      pcntl \
      sockets \
      redis \
      yaml \
      uuid \
      vips \
      msgpack \
      protobuf \
      imap \
      intl \
    && IPE_DONT_ENABLE=1 install-php-extensions xdebug \
    && rm -f /usr/local/bin/install-php-extensions

# Install Caddy
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
RUN setcap CAP_NET_BIND_SERVICE=+ep /usr/bin/caddy

# Configure PHP, allow_url_include is deprecated since PHP 7.4
RUN /usr/local/sbin/configure-php.sh && rm $PHP_INI_DIR/conf.d/allow_url_include.ini

#setup cron
RUN chown $USER:$GROUP /usr/sbin/crond \
    && setcap cap_setgid=ep /usr/sbin/crond

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# SET DEFAULT USER
RUN chmod +x /entrypoint.sh \
    && chmod +x /mode.sh \
    && mkdir -p /var/run/php-fpm/ \
    && mkdir -p /data \
    && mkdir -p /mautic \
    && mkdir -p /tmp/mautic \
    && chown $USER:$GROUP /var/run/php-fpm/ \
    && chown -R $USER:$GROUP /usr/local/docker-entrypoint.d/ \
    && chmod -R +x /usr/local/docker-entrypoint.d/ \
    && chown -R $USER:$GROUP /data \
    && chown -R $USER:$GROUP /mautic
USER $USER:$GROUP

# Define working directory
WORKDIR /data

ENV MAUTIC_SSL_ENABLED false
ENV MAUTIC_TLS_EMAIL none

# By default enable cron jobs
ENV MAUTIC_CRON_RUN_JOBS true

# By default install composer dependencies on startup
ENV MAUTIC_RUN_COMPOSER_INSTALL true


# By default apply database mirgrations on startup
ENV MAUTIC_RUN_MIGRATION true

# Expose ports
EXPOSE 80/tcp
EXPOSE 443/tcp

# Define entrypoint and command
ENTRYPOINT ["/mode.sh"]
CMD ["/entrypoint.sh"]