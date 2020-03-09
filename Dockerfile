ARG TARGETPLATFORM

FROM --platform=${TARGETPLATFORM:-linux/amd64} yobasystems/alpine-mariadb

LABEL maintainer="Jamie Curnow <jc@jc21.com>"

ADD 00_aria.cnf /etc/mysql/conf.d/00_aria.cnf
