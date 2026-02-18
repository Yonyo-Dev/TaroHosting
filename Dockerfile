FROM alpine:latest

# Instalación de dependencias y PHP 8.2 (versión estable recomendada)
RUN apk update && apk add --no-cache \
    curl \
    ca-certificates \
    nginx \
    git \
    unzip \
    tar \
    xz \
    php82 \
    php82-fpm \
    php82-curl \
    php82-dom \
    php82-gd \
    php82-json \
    php82-mbstring \
    php82-mysqli \
    php82-openssl \
    php82-pdo \
    php82-pdo_mysql \
    php82-pdo_sqlite \
    php82-phar \
    php82-simplexml \
    php82-xml \
    php82-xmlreader \
    php82-zip \
    php82-tokenizer \
    php82-ctype \
    php82-fileinfo \
    php82-session \
    php82-bcmath

# Instalar Composer desde la imagen oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear usuario y preparar entorno
RUN adduser -D -h /home/container container
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# El entrypoint lo manejará el Egg mediante el script de inicio
CMD ["/bin/ash"]
