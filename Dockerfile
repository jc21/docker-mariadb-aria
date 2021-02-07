ARG TARGETPLATFORM
ARG MARIADB_VERSION

FROM --platform=${TARGETPLATFORM:-linux/amd64} yobasystems/alpine-mariadb:${MARIADB_VERSION:-10.4.15}

LABEL maintainer="Jamie Curnow <jc@jc21.com>"

# mariadb does not appear to load conf.d files by default
#ADD 00_aria.cnf /etc/mysql/conf.d/00_aria.cnf

COPY 00_aria.cnf .
RUN cat /00_aria.cnf >> /etc/mysql/my.cnf

ARG BUILD_DATE
ARG BUILD_COMMIT

LABEL org.label-schema.schema-version="1.0" \
	org.label-schema.name="mariadb-aria" \
	org.label-schema.description="MariaDB with Aria engine used by default" \
	org.label-schema.build-date="${BUILD_DATE:-}" \
	org.label-schema.url="https://github.com/jc21/docker-mariadb-aria" \
	org.label-schema.vcs-url="https://github.com/jc21/docker-mariadb-aria.git" \
	org.label-schema.vcs-ref="${BUILD_COMMIT:-}" \
	org.label-schema.cmd="docker run -d jc21/mariadb-aria"
