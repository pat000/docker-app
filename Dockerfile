FROM php:7.4-apache

RUN apt-get update -y && apt-get install -y openssl zip unzip git 

RUN docker-php-ext-install pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chown -R www-data:www-data /var/www/html && a2enmod rewrite

COPY . /var/www/html

COPY docker/vhost.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

RUN php artisan key:generate
RUN chmod -R 777 storage
RUN a2enmod rewrite
RUN service apache2 restart