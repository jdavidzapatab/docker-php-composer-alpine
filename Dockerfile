FROM php:5.6-alpine

LABEL maintainer="David Zapata <jdavid.zapatab@gmail.com>"

RUN mkdir -p /var/www
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

WORKDIR /var/www
COPY . /var/www
VOLUME /var/www

EXPOSE 80 8000

CMD ["sh"]