FROM php:7.4-alpine

LABEL maintainer="David Zapata <jdavid.zapatab@gmail.com>"

RUN mkdir -p /var/www
RUN apk add --no-cache $PHPIZE_DEPS
RUN apk add --no-cache zip
RUN apk add --no-cache
RUN apk add --no-cache libzip-dev
RUN apk add --no-cache libxml2-dev
RUN apk add --no-cache libmcrypt-dev
RUN apk add --no-cache freetype-dev
RUN apk add --no-cache libjpeg-turbo-dev
RUN apk add --no-cache libpng-dev
RUN apk add --no-cache imagemagick
RUN apk add --no-cache imagemagick-libs
RUN apk add --no-cache imagemagick-dev
RUN apk add --no-cache php7-imagick
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN pecl install --nodeps mcrypt-snapshot
RUN docker-php-ext-enable mcrypt
RUN docker-php-ext-configure zip
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install soap
RUN docker-php-ext-install pcntl
RUN docker-php-ext-configure gd --with-jpeg --with-freetype
RUN docker-php-ext-install gd
RUN pecl install imagick
RUN docker-php-ext-enable --ini-name 20-imagick.ini imagick
RUN pecl install pcov
RUN docker-php-ext-enable pcov
RUN pecl install redis
RUN docker-php-ext-enable redis
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

WORKDIR /var/www
COPY . /var/www
VOLUME /var/www

EXPOSE 80 8000

CMD ["sh"]