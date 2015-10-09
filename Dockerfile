FROM ubuntu:trusty
MAINTAINER dbourasseau@viotech.net

ENV SQUID_VERSION=3.3.8 \
    SQUID_CACHE_DIR=/var/spool/squid3 \
    SQUID_LOG_DIR=/var/log/squid3 \
    SQUID_USER=proxy

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6 \
 && echo "deb http://ppa.launchpad.net/brightbox/squid-ssl/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y squid3-ssl=${SQUID_VERSION}*  apache2 squid-cgi\
 && mv /etc/squid3/squid.conf /etc/squid3/squid.conf.dist \
 && rm -rf /var/lib/apt/lists/*

#RUN mv cp /etc/apache2/sites-available/000-default.conf cp /etc/apache2/sites-available/000-default.conf.dist \
RUN a2enmod cgid
COPY squid.conf /etc/squid3/squid.conf
COPY apache.conf /etc/apache2/sites-available/000-default.conf
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
EXPOSE 80/tcp
VOLUME ["${SQUID_CACHE_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
