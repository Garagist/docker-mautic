FROM oidagroup/php-worker:8.1

USER root:root

RUN apk add nodejs npm vim

# Copy configuration
COPY root /

RUN mkdir /mautic
RUN mkdir /data/.docker-entrypoint.d
RUN chown docker:docker /mautic
RUN chown docker:docker /data/.docker-entrypoint.d
RUN chown docker:docker /entrypoint.sh
RUN chown docker:docker /mode.sh
RUN chown -R docker:docker /home/docker
RUN chmod +x /mode.sh
RUN chmod +x /entrypoint.sh

USER docker:docker

ENV MAUTIC_SSL_ENABLED false
ENV MAUTIC_TLS_EMAIL none

# By default enable cron jobs
ENV MAUTIC_CRON_RUN_JOBS true

# By default install composer dependencies on startup
ENV MAUTIC_RUN_COMPOSER_INSTALL true

# By default apply database mirgrations on startup
ENV MAUTIC_RUN_MIGRATION true

COPY .mautic/composer.json /data/composer.json

# Expose ports
EXPOSE 80/tcp
EXPOSE 443/tcp

RUN ls -lah /

# Define entrypoint and command
ENTRYPOINT ["/mode.sh"]
CMD ["/entrypoint.sh"]