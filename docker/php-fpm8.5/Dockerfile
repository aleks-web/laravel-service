FROM php:8.5-fpm-alpine

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer


RUN apk update && apk upgrade
RUN apk add --no-cache libjpeg-turbo-dev libwebp-dev libpng-dev
RUN apk add --no-cache openssh-server
RUN apk add --no-cache unzip libzip-dev
RUN apk add --no-cache nano git
RUN apk add --no-cache gmp gmp-dev
RUN apk add --no-cache freetype-dev


RUN docker-php-ext-install zip
RUN docker-php-ext-install gmp
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql
RUN docker-php-ext-install gd
RUN apk add --no-cache pcre-dev $PHPIZE_DEPS

# configure gd
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

ARG UNAME

WORKDIR /var/www/laravel
CMD chmod -R 777 /var/www/laravel

CMD ["php-fpm", "-R"]