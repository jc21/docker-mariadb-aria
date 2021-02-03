ARG TARGETPLATFORM

FROM --platform=${TARGETPLATFORM:-linux/amd64} yobasystems/alpine-mariadb

LABEL maintainer="Jamie Curnow <jc@jc21.com>"

# mariadb does not appear to load conf.d files by default
#ADD 00_aria.cnf /etc/mysql/conf.d/00_aria.cnf

COPY 00_aria.cnf .
RUN cat /00_aria.cnf >> /etc/mysql/my.cnf

# secret-init.sh requires bash for variable expanshiopn
RUN apk add --no-cache bash && \
    rm -f /var/cache/apk/*

COPY ./scripts/secret-init.sh /scripts/pre-init.d
COPY ./scripts/secret-init.sh /scripts/
# COPY ./scripts/01_run_secret-init.bash /scripts/pre-init.d
COPY ./scripts/02_check-env.sh /scripts/pre-init.d
