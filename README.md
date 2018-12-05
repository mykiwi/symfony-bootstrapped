
## Environments 

### Docker 

* mariadb:10.3
* nginx:1-alpine
* php : custom container based on php:7.2-fpm-alpine (see file docker/php/Dockerfile)
* node : custom container based on node:9.2-alpine (see file docker/node/Dockerfile)

## Install

    make          # self documented makefile
    make install  # install and start the project

Test the project : [http://localhost:8080](http://localhost:8080)

**Note**:

If the port 8080 is already used, change it in the docker-compose.yml for the service http 

```yml
(...)
    http:
    image: nginx:1-alpine
    depends_on:
      - php
    volumes:
      - ./docker/nginx/vhost.conf:/etc/nginx/conf.d/default.conf:ro
      - ./public/:/srv/public/:ro
    ports:
      - "8080:80" # Change the port 8080 for another unused one if necessary

(...)
```

## Start/Stop the projet

    make start
    make stop

## Utilities

Display all make command's line available for the project

    make

If you need to do a specific `bin/console` command you can do this : `make console cmd="command"` 

For example for clearing the cache : 

    bin/console cmd="cache:clear"
    
will be the same as :
    
    bin/console cache:clear

