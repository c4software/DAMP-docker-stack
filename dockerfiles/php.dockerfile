FROM php:8.2-apache

RUN apt-get clean
RUN apt-get update

#install some base extensions
RUN apt-get install -y zlib1g-dev libzip-dev zip libpng-dev

RUN docker-php-ext-install bcmath mysqli pdo pdo_mysql exif gd zip
RUN a2enmod userdir
RUN a2enmod rewrite

RUN sed -i 's/Options -Indexes/Options +Indexes/g' /etc/apache2/conf-enabled/docker-php.conf
