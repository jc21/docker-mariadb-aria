FROM mariadb

MAINTAINER Jamie Curnow <jc@jc21.com>
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

ADD 00_aria.cnf /etc/mysql/conf.d/00_aria.cnf

