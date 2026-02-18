FROM alpine:3.20

# Metadatos
LABEL author="TaroHosting" maintainer="admin@tarohosting.com"

# 1. Instalamos herramientas base y PHP 8.3 (Nativo)
RUN apk update && apk add --no-cache \
    curl ca-certificates nginx git unzip tar xz bash \
    php83 php83-fpm php83-mysqli php83-curl php83-mbstring php83-xml php83-zip php83-bcmath php83-gd php83-pdo_mysql

# 2. Instalamos PHP 8.2 (Compatible con 3.20)
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.19/community \
    php82 php82-fpm php82-mysqli php82-curl php82-mbstring php82-xml php82-zip php82-bcmath php82-gd php82-pdo_mysql

# 3. TRUCO PARA PHP 8.1: Instalamos librerías antiguas necesarias manualmente
RUN wget http://dl-cdn.alpinelinux.org/alpine/v3.16/main/x86_64/openssl-1.1-compat-1.1.1t-r2.apk && \
    apk add --no-cache --allow-untrusted openssl-1.1-compat-1.1.1t-r2.apk && \
    rm openssl-1.1-compat-1.1.1t-r2.apk

# 4. Instalamos PHP 8.1 (Sin el módulo GD que es el que causa el conflicto de 'libavif')
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.16/community \
    php81 php81-fpm php81-mysqli php81-curl php81-mbstring php81-xml php81-zip php81-bcmath php81-pdo_mysql

# 5. Instalamos Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. Configuración de usuario para Pterodactyl
RUN adduser -D -h /home/container container
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

CMD ["/bin/bash"]
