FROM alpine
MAINTAINER atsushi <atsushi@ageet.com>

WORKDIR /usr/src/kamailio

ARG KAMAILIO_VERSION=5.2.0
RUN apk add --update --no-cache \
    alpine-sdk \
    linux-headers \
    flex \
    bison \
    libxml2 \
    rtpproxy \
    openssl-dev

RUN wget -O - "https://github.com/kamailio/kamailio/archive/$KAMAILIO_VERSION.tar.gz" | tar zxvf - --strip-components=1 && \
  make include_modules="tls" cfg && make all && make install && make distclean && rm -rf ./*

ENV ENTRYKIT_VERSION 0.4.0
RUN wget -O - "https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz" | tar zxf - -C /bin \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

COPY ./kamailio-local.cfg.tmpl /usr/local/etc/kamailio
COPY ./entrypoint.sh.tmpl .

RUN openssl req -x509 -out /usr/local/etc/kamailio/cert.pem -keyout /usr/local/etc/kamailio/key.pem \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost'

COPY ./tls.cfg /usr/local/etc/kamailio

EXPOSE 5060-5061 5060/udp
ENTRYPOINT [ \
  "render", \
    "/usr/local/etc/kamailio/kamailio-local.cfg", \
    "entrypoint.sh", "--", \
  "prehook", "chmod a+x entrypoint.sh", "--", \
  "./entrypoint.sh" ]
