FROM alpine:3.19

# Metadatos de TaroHosting
LABEL author="TaroHosting" maintainer="admin@tarohosting.com"

# 1. Instalamos herramientas base
RUN apk update && apk add --no-cache \
    curl ca-certificates nginx git unzip tar xz bash

# 2. PHP 8.3 (Desde el repositorio Edge de Alpine)
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    php83 php83-fpm php83-mysqli php83-curl php83-mbstring php83-xml php83-zip php83-bcmath php83-gd php83-pdo_mysql

# 3. PHP 8.2 (Nativo de Alpine 3.19)
RUN apk add --no-cache \
    php82 php82-fpm php82-mysqli php82-curl php82-mbstring php82-xml php82-zip php82-bcmath php82-gd php82-pdo_mysql

# 4. PHP 8.1 (Desde v3.16) - Instalamos solo lo esencial para evitar conflictos de SSL
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.16/main openssl-1.1-compat || true
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.16/community \
    php81 php81-fpm php81-mysqli php81-curl php81-mbstring php81-xml php81-zip php81-pdo_mysql

# 5. Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. Usuario Pterodactyl
RUN adduser -D -h /home/container container
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

CMD ["/bin/bash"]
