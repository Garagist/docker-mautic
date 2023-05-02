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
   image: garagist/mautic:composer-7.4
   environment:
     - MAUTIC_CONTEXT=Development
   volumes:
     - ./:/data
     - .mautic/config:/config
```
### Production run
Set the MAUTIC_CONTEXT to production and you are ready to go
```
version: '3.7'
services:
 mautic:
   image: garagist/mautic:composer-7.4
   environment:
     - MAUTIC_CONTEXT=Production
     - MAUTIC_SSL_ENABLED=True
     - MAUTIC_TLS_EMAIL=your@emila.loc
   volumes:
     - .mautic/config:/config
```

### Env variables
- MAUTIC_CONTEXT=Development
- MAUTIC_CRON_RUN_JOBS=true
- MAUTIC_RUN_COMPOSER_INSTALL=true
- MAUTIC_RUN_MIGRATION=true

### Upgrade Mautic instance
Update your composer configuration accordingly, check your custom plugins for compatibility and restart the container. Just make sure `MAUTIC_RUN_MIGRATION` is enabled.

### Recommended mautic composer file
https://packagist.org/packages/mautic/recommended-project

## TODO's
- Test oAuth support

## Kudos
This image is heavily inspired by the awesome work of ttree/flowapp. Thx for sharing :-)
