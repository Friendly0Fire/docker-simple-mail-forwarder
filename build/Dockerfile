FROM alpine:latest

ENV S6_VERSION 1.22.1.0

## Install System

RUN apk add --update --no-cache \
        bash \
        curl \
        cyrus-sasl \
        drill \
        logrotate \
        openssl \
        postfix \
        syslog-ng \
        ca-certificates \
        tzdata

## Install s6 process manager
RUN curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz \
  | tar xzf - -C /

## Configure Service

COPY install/main.dist.cf      /etc/postfix/main.cf
COPY install/master.dist.cf    /etc/postfix/master.cf
COPY install/postfix-files     /etc/postfix/postfix-files
COPY install/syslog-ng.conf    /etc/syslog-ng/syslog-ng.conf

RUN mkdir /etc/postfix/db.dist

COPY install/sasl_passwd.dist              /etc/postfix/db.dist/sasl_passwd
COPY install/transport_maps_regexp.dist    /etc/postfix/db.dist/transport_maps_regexp
COPY install/transport_maps.dist           /etc/postfix/db.dist/transport_maps
COPY install/virtual_alias_regexp.dist     /etc/postfix/db.dist/virtual_alias_regexp
COPY install/virtual_alias.dist            /etc/postfix/db.dist/virtual_alias

RUN chown root:root /etc/postfix/db.dist/sasl_passwd
RUN chmod 700 /etc/postfix/db.dist/sasl_passwd

RUN chown root:root /etc/postfix/main.cf && chown root:root /etc/postfix/master.cf
RUN chmod 700 /etc/postfix/main.cf && chmod 700 /etc/postfix/master.cf

RUN mkdir /etc/postfix/db

COPY install/postfix.sh /etc/services.d/postfix/run
RUN bash -n /etc/services.d/postfix/run && chmod +x /etc/services.d/postfix/run

COPY install/syslog-ng.sh /etc/services.d/syslog-ng/run
RUN bash -n /etc/services.d/syslog-ng/run && chmod +x /etc/services.d/syslog-ng/run

COPY entrypoint.sh /entrypoint.sh
RUN bash -n /entrypoint.sh && chmod a+x /entrypoint.sh

RUN chown -R root:root /var/spool/postfix && chmod -R 755 /var/spool/postfix

VOLUME ["/var/spool/postfix"]

EXPOSE 25
EXPOSE 587

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]

