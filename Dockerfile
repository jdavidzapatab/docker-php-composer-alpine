FROM php:7.4-alpine

LABEL maintainer="David Zapata <jdavid.zapatab@gmail.com>"

RUN mkdir -p /var/www
RUN apk update && apk upgrade && \
    apk add --no-cache $PHPIZE_DEPS && \
    apk add --no-cache zip && \
    apk add --no-cache libzip-dev && \
    apk add --no-cache libxml2-dev && \
    apk add --no-cache libmcrypt-dev && \
    apk add --no-cache freetype-dev && \
    apk add --no-cache libjpeg-turbo-dev && \
    apk add --no-cache libpng-dev && \
    apk add --no-cache imagemagick && \
    apk add --no-cache imagemagick-libs && \
    apk add --no-cache imagemagick-dev && \
    pecl install --nodeps mcrypt-snapshot
RUN docker-php-ext-enable mcrypt && \
    docker-php-ext-configure zip && \
    docker-php-ext-install bcmath && \
    docker-php-ext-install zip && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install soap && \
    docker-php-ext-install pcntl && \
    docker-php-ext-configure gd --with-jpeg --with-freetype && \
    docker-php-ext-install gd
RUN pecl install imagick && \
    docker-php-ext-enable --ini-name 20-imagick.ini imagick
RUN pecl install pcov && \
    docker-php-ext-enable pcov
RUN pecl install redis && \
    docker-php-ext-enable redis
RUN pecl install mongodb && docker-php-ext-enable mongodb
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions
RUN sync
RUN install-php-extensions xdebug
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

WORKDIR /var/www
COPY . /var/www
VOLUME /var/www

EXPOSE 80 8000

CMD ["sh"]