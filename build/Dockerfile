FROM alpine:3.8

ENV S6_VERSION 1.21.7.0

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
        ca-certificates-bundle \
        tzdata

## Install s6 process manager
RUN curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz \
  | tar xzf - -C /

## Configure Service

COPY install/main.dist.cf /etc/dist/main.cf
COPY install/master.dist.cf /etc/dist/master.cf
COPY install/syslog-ng.conf /etc/dist/syslog-ng.conf

RUN cat /dev/null > /etc/postfix/aliases && newaliases

COPY install/postfix.sh /etc/services.d/postfix/run
RUN bash -n /etc/services.d/postfix/run && chmod +x /etc/services.d/postfix/run

COPY install/syslog-ng.sh /etc/services.d/syslog-ng/run
RUN bash -n /etc/services.d/syslog-ng/run && chmod +x /etc/services.d/syslog-ng/run

COPY entrypoint.sh /entrypoint.sh
RUN bash -n /entrypoint.sh && chmod a+x /entrypoint.sh

VOLUME ["/var/spool/postfix"]

EXPOSE 25

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]

