FROM alpine:3.8
MAINTAINER franck@besnard.mobi 

RUN \
  apk add --no-cache \
   apache-mod-fcgid \
   apache2-ctl \
   apache2-proxy \
   apache2-ssl \
   apache2-utils \
   curl \
   git \
   logrotate \
   nano \
   openssl \
   php7 \
   php7-apache2 \
   php7-cli \
   php7-curl \
   php7-fpm \
   apache2-webdav && \
  sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf

RUN mkdir /data && \
	mkdir /conf && \
	mkdir /bootstrap

COPY root/ /

EXPOSE 80 443


