FROM nginx:alpine

LABEL maintainer="Matthieu Bargheon <bh@bhtech.io>"
LABEL git="https://github.com/bh42/docker-nginx-reverseproxy-letsencrypt"
LABEL version="0.1"

VOLUME ["/certs", "/conf"]

RUN apk add netcat-openbsd bc curl wget git bash openssl libressl nginx-mod-http-geoip

RUN cd /tmp/ && git clone https://github.com/acmesh-official/acme.sh.git

RUN cd /tmp/acme.sh/ && ./acme.sh --install && rm -rf /tmp/acme.sh

WORKDIR /root/.acme.sh/

RUN mkdir -vp /var/www/html/.well-known/acme-challenge/

COPY entrypoint.sh /root/.acme.sh/

COPY service.conf.template /tmp

RUN chmod +x /root/.acme.sh/entrypoint.sh

RUN rm -rf /etc/nginx/conf.d && ln -s /conf /etc/nginx/conf.d

# RUN wget https://dl.miyuru.lk/geoip/maxmind/country/maxmind4.dat.gz && gunzip maxmind4.dat.gz

# COPY maxmind4.dat /usr/share/GeoIPCountry.dat

ENTRYPOINT [ "/root/.acme.sh/entrypoint.sh" ]
