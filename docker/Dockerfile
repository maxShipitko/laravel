FROM php:7.4-fpm-alpine

RUN apk add --no-cache $PHPIZE_DEPS && \
    pecl install xdebug && docker-php-ext-enable xdebug && \
    docker-php-ext-install pdo_mysql

VOLUME /app