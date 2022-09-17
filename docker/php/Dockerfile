FROM php:8.1-fpm

ENV ACCEPT_EULA=Y

RUN apt-get update && \
    apt-get install -my unzip wget cron git zlib1g-dev libicu-dev wget gnupg

# Install Core Extensions
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install xdebug-3.2.0alpha3 \
    && docker-php-ext-enable xdebug

# PostgreSQL
RUN apt-get update && apt-get install -y libpq-dev && docker-php-ext-install pdo pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set TimeZone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone \
&& printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini \
&& "date"

# Remove install-packeges
RUN apt-get -y autoremove \
    && apt-get clean && rm -rf /tmp/*

EXPOSE 9000
