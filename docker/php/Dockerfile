FROM composer

FROM php:7.2-fpm-alpine

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

ENV APCU_VERSION 5.1.8

RUN apk add --no-cache \
        ca-certificates \
        icu-libs \
        git \
        unzip \
        zlib-dev && \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev && \
    docker-php-ext-install \
        intl \
        zip && \
    pecl install apcu-${APCU_VERSION} && \
    docker-php-ext-enable apcu && \
    docker-php-ext-enable opcache && \
    docker-php-ext-install pdo_mysql && \
    echo "short_open_tag = off" >> /usr/local/etc/php/php.ini && \
    echo "date.timezone = Europe/Paris" >> /usr/local/etc/php/conf.d/symfony.ini && \
    echo "opcache.max_accelerated_files = 20000" >> /usr/local/etc/php/conf.d/symfony.ini && \
    echo "realpath_cache_size=4096K" >> /usr/local/etc/php/conf.d/symfony.ini && \
    echo "realpath_cache_ttl=600" >> /usr/local/etc/php/conf.d/symfony.ini && \
    apk del .build-deps && \
    apk add gosu --update --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    addgroup bar && \
    adduser -D -h /home -s /bin/sh -G bar foo

ADD entrypoint.sh /entrypoint

ENTRYPOINT ["/entrypoint"]
