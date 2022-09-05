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

COPY root/etc/Caddyfile /etc/Caddyfile

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
    && apk --update add curl libcap git \
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
    && IPE_DONT_ENABLE=1 install-php-extensions xdebug \
    && rm -f /usr/local/bin/install-php-extensions

# Install Caddy
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
RUN setcap CAP_NET_BIND_SERVICE=+ep /usr/bin/caddy

# Configure PHP, allow_url_include is deprecated since PHP 7.4
RUN /usr/local/sbin/configure-php.sh && rm $PHP_INI_DIR/conf.d/allow_url_include.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer


# SET DEFAULT USER
RUN chmod +x /entrypoint.sh \
    && chmod +x /mode.sh \ 
    && mkdir -p /var/run/php-fpm/ \
    && mkdir -p /data \
    && chown $USER:$GROUP /var/run/php-fpm/ \
    && chown -R $USER:$GROUP /data;
USER $USER:$GROUP


# Define working directory
WORKDIR /data

# By default enable cron jobs
ENV MAUTIC_RUN_CRON_JOBS true

# Setting an Default database user for Mysql
ENV MAUTIC_DB_USER root

# Setting an Default database name for Mysql
ENV MAUTIC_DB_NAME mautic

# Expose ports
EXPOSE 80/tcp
EXPOSE 443/tcp

# Define entrypoint and command
ENTRYPOINT ["/mode.sh"]
CMD ["/entrypoint.sh"]