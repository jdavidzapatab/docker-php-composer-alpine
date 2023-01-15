FROM php:7.4-alpine

LABEL maintainer="David Zapata <jdavid.zapatab@gmail.com>"

RUN mkdir -p /var/www
RUN apk add --no-cache $PHPIZE_DEPS
RUN apk add --no-cache zip libzip-dev libxml2-dev libmcrypt-dev freetype-dev libjpeg-turbo-dev libpng-dev imagemagick imagemagick-libs imagemagick-dev php7-imagick
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN pecl install --nodeps mcrypt-snapshot && docker-php-ext-enable mcrypt
RUN docker-php-ext-configure zip
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install soap
RUN docker-php-ext-install pcntl
RUN docker-php-ext-configure gd --with-jpeg --with-freetype
RUN docker-php-ext-install gd
RUN pecl install imagick && docker-php-ext-enable --ini-name 20-imagick.ini imagick
RUN pecl install pcov && docker-php-ext-enable pcov
RUN pecl install redis && docker-php-ext-enable redis
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

WORKDIR /var/www
COPY . /var/www
VOLUME /var/www

EXPOSE 80 8000

CMD ["sh"]