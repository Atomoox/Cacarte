FROM php:8.2-apache

RUN apt-get update && apt-get install -y nano

RUN apt-get install -y libpq-dev && docker-php-ext-install pdo pdo_pgsql
RUN apt-get install -y zip

RUN mkdir -p /var/run/apache2/

RUN apt-get install -y git

COPY .netrc /root/.netrc

WORKDIR /var/www/html/

RUN git clone https://github.com/Atomoox/Cacarte.git /var/www/html/

RUN echo '<?php echo phpinfo();' > index.php
RUN echo 'max_execution_time = 400' >> /usr/local/etc/php/conf.d/docker-php-maxexectime.ini;

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.mode=debug,profile" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/php.ini-development \
    && echo "xdebug.mode=debug,profile" >> /usr/local/etc/php/php.ini-development \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/php.ini-development \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/php.ini-development \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/php.ini-development
