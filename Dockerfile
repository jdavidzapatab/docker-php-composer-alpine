FROM php:7.4-alpine

LABEL maintainer="David Zapata <jdavid.zapatab@gmail.com>"

RUN mkdir -p /var/www \
    && apk add --no-cache $PHPIZE_DEPS \
    && apk add --no-cache zip libzip-dev libxml2-dev libmcrypt-dev freetype-dev libjpeg-turbo-dev libpng-dev imagemagick imagemagick-libs imagemagick-dev php7-imagick \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && pecl install --nodeps mcrypt-snapshot && docker-php-ext-enable mcrypt \
    && docker-php-ext-configure zip \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install soap \
    && docker-php-ext-install pcntl \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd \
    && pecl install imagick && docker-php-ext-enable --ini-name 20-imagick.ini imagick \
    && pecl install pcov && docker-php-ext-enable pcov \
    && pecl install redis && docker-php-ext-enable redis \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

WORKDIR /var/www
COPY . /var/www
VOLUME /var/www

EXPOSE 80 8000

CMD ["sh"]