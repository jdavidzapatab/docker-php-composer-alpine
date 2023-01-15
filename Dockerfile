FROM php:8.0-alpine

LABEL maintainer="David Zapata <jdavid.zapatab@gmail.com>"

RUN mkdir -p /var/www
RUN apk add --no-cache $PHPIZE_DEPS
RUN apk add --no-cache zip
RUN apk add --no-cache libzip-dev
RUN apk add --no-cache libxml2-dev
RUN apk add --no-cache libmcrypt-dev
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN pecl install --nodeps mcrypt-snapshot
RUN docker-php-ext-enable mcrypt
RUN docker-php-ext-configure zip
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install soap
RUN pecl install redis
RUN docker-php-ext-enable redis
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

WORKDIR /var/www
COPY . /var/www
VOLUME /var/www

EXPOSE 80 8000

CMD ["sh"]