FROM alpine:latest

# Instalamos herramientas base
RUN apk update && apk add --no-cache \
    curl ca-certificates nginx git unzip tar xz bash

# Instalamos PHP 8.1, 8.2 y 8.3 con sus módulos comunes
# Usamos el repositorio edge/community para asegurar disponibilidad
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.15/community php81 php81-fpm php81-mysqli php81-curl php81-mbstring php81-xml php81-zip
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.19/community php82 php82-fpm php82-mysqli php82-curl php82-mbstring php82-xml php82-zip
RUN apk add --no-cache php83 php83-fpm php83-mysqli php83-curl php83-mbstring php83-xml php83-zip

# Composer global
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN adduser -D -h /home/container container
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

CMD ["/bin/bash"]
