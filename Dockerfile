FROM php:7.4-alpine

LABEL maintainer="David Zapata <jdavid.zapatab@gmail.com>"

# Use multi-stage copying for Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install system dependencies and PHP extensions in a single layer
# This optimizes image size by avoiding unnecessary layers and cleaning up build dependencies.
# Upgrades the entire Alpine base to v3.20 for security, while keeping v3.16 for legacy libssl1.1 compatibility.
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.20/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.20/community" >> /etc/apk/repositories && \
    echo "@v3.16 http://dl-cdn.alpinelinux.org/alpine/v3.16/main" >> /etc/apk/repositories && \
    apk upgrade --no-cache && \
    apk add --no-cache \
        musl \
        tar \
        curl \
        busybox \
        git \
        xz \
        xz-libs \
        glib \
        bash \
        libzip \
        libpng \
        libjpeg-turbo \
        freetype \
        imagemagick \
        libssl1.1@v3.16 \
    && curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o /usr/local/bin/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions \
    && sync \
    && install-php-extensions \
        bcmath \
        gd \
        imagick \
        mcrypt \
        mongodb \
        pcntl \
        pcov \
        pdo_mysql \
        redis \
        soap \
        xdebug \
        zip \
    && rm /usr/local/bin/install-php-extensions \
    && rm -rf /var/cache/apk/* /tmp/*

# Use the production PHP configuration and apply basic security hardening
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && sed -i 's/expose_php = On/expose_php = Off/g' "$PHP_INI_DIR/php.ini"

# Set up working directory
WORKDIR /var/www

# Copy application files and set ownership to non-root user
COPY --chown=www-data:www-data . /var/www

# Use non-root user (www-data) for improved security
USER www-data

# Expose common ports
EXPOSE 80 8000

# Persistent volume for application data
VOLUME /var/www

# Default command
CMD ["sh"]