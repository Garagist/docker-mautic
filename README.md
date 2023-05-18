# Mautic Docker Image
Unofficial Mautic docker image for cloud infrastructure deployments. 
## Why?
The official docker image is not suited for running in cluster environments. This project aims to improve that by focusing on a strict 'composer only' setup with a few config modifications and a customizable startup routine.

### Key benefits
1. dedicated docker user (no root execution)
2. fixuid for development context (mounted source)
3. dedicated directories for config and cache data (outside of document root)
4. cloud ready startup routine with composer install and database migrations

### Default startup sequence scripts (`/usr/local/docker-entrypoint.d`)
1. Move config and cache data away from the document root.
2. Automatically run composer install on each startup (optional)
3. Automatically run Mautic migrations on each startup (optional)
4. Setup cron jobs (optional)

### Custom startup sequence scripts (`/data/docker-entrypoint.d`)
You may add custom startup scripts via volume mounts or project-specific images to configure Mautic accordingly to your needs. The scripts are executed in alphabetical order. We recommend to add a number to the file name. For instance: `100_hello-world.sh`. 
#### Example
```
#!/bin/sh

echo "hello world"

exit 0
```

## Getting started
The image does not contain a composer.json or composer.lock file. It is recommended to use this image as a base image for "custom project" or "fixed version" images.
### Quick run
Mount a composer.json configuration and start the container:
```docker run -it -p 8001:80 -v "$(pwd)"/composer.json:/data/composer.json mautic-composer```
### Development run
If you would like to use the image to improve Mautic itself, or if you are working on a customer project, you just have to mount the document root folder and the config folder for persistence:
```
version: '3.7'
services:
 mautic:
   image: garagist/mautic:composer-8.0
   environment:
     - MAUTIC_CONTEXT=Development
     - MAUTIC_DOMAIN=mautic.your.domain
     - MAUTIC_DB_HOST=db
     - MAUTIC_DB_USER=db-user
     - MAUTIC_DB_PASSWORD=db-password
     - MAUTIC_DB_NAME=db-name
   volumes:
     - ./:/data
     - .mautic/config:/mautic/config
```
### Production run
Set the MAUTIC_CONTEXT to production and you are ready to go
```
version: '3.7'
services:
 mautic:
   image: garagist/mautic:composer-8.0
   environment:
     - MAUTIC_CONTEXT=Production
     - MAUTIC_DOMAIN=mautic.your.domain
     - MAUTIC_SSL_ENABLED=True
     - MAUTIC_TLS_EMAIL=your@your.domain
     - MAUTIC_DB_HOST=db
     - MAUTIC_DB_USER=db-user
     - MAUTIC_DB_PASSWORD=db-password
     - MAUTIC_DB_NAME=db-name
   volumes:
     - .mautic/config:/mautic/config
```

### Env variables defaults
- MAUTIC_CONTEXT=Development # Development or Production
- MAUTIC_CRON_RUN_JOBS=True # Whether to run cron jobs or not
- MAUTIC_RUN_COMPOSER_INSTALL=true # Whether to run composer install or not
- MAUTIC_RUN_MIGRATION=True # Whether to run database migrations or not
- MAUTIC_DOMAIN=http:// # serv every domain 
- MAUTIC_SSL_ENABLED=False # Whether to enable SSL or not
- MAUTIC_TLS_EMAIL=none # Email address for Let's Encrypt
- MAUTIC_DB_HOST=db # Database host
- MAUTIC_DB_USER=db-user # Database user
- MAUTIC_DB_PASSWORD=db-password # Database password
- MAUTIC_DB_NAME=db-name # Database name

- PHP_TIMEZONE=UTC
- PHP_MEMORY_LIMIT=512M
- PHP_UPLOAD_MAX_FILESIZE=256M
- PHP_UPLOAD_MAX_FILESIZE=256M
- PHP_ALLOW_URL_INCLUDE=1
- PHP_MAX_EXECUTION_TIME=240
- PHP_MAX_INPUT_VARS=1500

### Upgrade Mautic instance
Update your composer configuration accordingly, check your custom plugins for compatibility and restart the container. Just make sure `MAUTIC_RUN_MIGRATION` is enabled.

### Recommended mautic composer file
https://packagist.org/packages/mautic/recommended-project

## TODO's
- Test oAuth support

## Kudos
This image is heavily inspired by the awesome work of ttree/flowapp. Thx for sharing :-)
