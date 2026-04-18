FROM php:8.1-alpine

LABEL maintainer="David Zapata <jdavid.zapatab@gmail.com>"

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.23/main" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk update && apk upgrade && \
    apk add --no-cache \
        tar=1.35-r5 \
        curl=8.19.0-r0 \
        busybox=1.37.0-r31 \
        sqlite=3.53.0-r0 \
        sqlite-libs=3.53.0-r0 \
        libavif=1.4.1-r0 \
        nghttp2=1.68.1-r0 \
        nghttp2-libs=1.68.1-r0 \
        lz4=1.10.0-r1 \
        lz4-libs=1.10.0-r1
RUN chmod +x /usr/local/bin/install-php-extensions \
    && mkdir -p /var/www \
    && install-php-extensions xdebug \
    && install-php-extensions gd \
    && install-php-extensions mcrypt \
    && install-php-extensions zip \
    && install-php-extensions bcmath \
    && install-php-extensions pdo_mysql \
    && install-php-extensions soap \
    && install-php-extensions redis \
    && install-php-extensions pcntl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN rm -rf /var/cache/apk/*

WORKDIR /var/www
COPY . /var/www
VOLUME /var/www

EXPOSE 80 8000

CMD ["sh"]