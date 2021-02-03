ARG TARGETPLATFORM

FROM --platform=${TARGETPLATFORM:-linux/amd64} yobasystems/alpine-mariadb

LABEL maintainer="Jamie Curnow <jc@jc21.com>"

# mariadb does not appear to load conf.d files by default
#ADD 00_aria.cnf /etc/mysql/conf.d/00_aria.cnf

COPY 00_aria.cnf .
RUN cat /00_aria.cnf >> /etc/mysql/my.cnf

COPY ./scripts/01_secret-init.sh /scripts/pre-init.d
