#!/bin/sh

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/nginx/ssl/ssl.key -out /etc/nginx/ssl/ssl.crt -subj "/C=FR/ST=PB/L=PAYS-BASQUE/O=42/OU=42/CN=acomet.42.fr/UID=acomet"

COPY conf/nginx.conf etc/nginx/
COPY conf/default.conf etc/nginx/http.d/


"chmod", "700", "etc/nginx/ssl"]
ENTRYPOINT ["nginx", "-g", "daemon off;"]
