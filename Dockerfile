# Use official composer image as a build stage
FROM composer:2 AS composer

# Use official php 8.0 alpine image
# PHP 8.0 is reaching EOL, so we use Alpine 3.16 which is the latest officially supported base for this version
FROM php:8.0-alpine

LABEL maintainer="David Zapata <jdavid.zapatab@gmail.com>"

# Set the working directory
WORKDIR /var/www

# Install system dependencies, PHP extensions and PECL modules
# Consolidate RUN commands to keep the image slim and reduce layers
# Core security updates for curl, xz, busybox, and tar are pulled from edge to fix CVEs
RUN set -xe && \
    apk update && \
    apk upgrade && \
    apk add --no-cache \
        zip \
        libzip \
        libxml2 \
        libmcrypt && \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        linux-headers \
        libzip-dev \
        libxml2-dev \
        libmcrypt-dev && \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        pdo_mysql \
        soap \
        zip && \
    pecl install xdebug redis mcrypt-snapshot && \
    docker-php-ext-enable xdebug redis mcrypt && \
    apk del .build-deps && \
    apk add --no-cache --upgrade \
        --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main \
        tar \
        curl \
        libcurl \
        busybox \
        xz && \
    rm -rf /tmp/* /var/cache/apk/* /usr/src/php*

# Copy composer from the composer stage
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Copy the application code (if any, filtered by .dockerignore)
COPY . /var/www

# Set volume for the application
VOLUME /var/www

# Expose ports
EXPOSE 80 8000

# Default command
CMD ["sh"]