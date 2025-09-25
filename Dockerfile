ARG MARIADB_VERSION=10.11.5

FROM yobasystems/alpine-mariadb:${MARIADB_VERSION}
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

RUN apk add --no-cache tzdata

COPY 00_aria.cnf /etc/my.cnf.d/00_aria.cnf
COPY ./scripts/01_secret-init.sh /scripts/pre-init.d

ARG BUILD_DATE=now
ARG BUILD_COMMIT=unknown

LABEL org.label-schema.schema-version="1.0" \
	org.label-schema.name="mariadb-aria" \
	org.label-schema.description="MariaDB with Aria engine used by default" \
	org.label-schema.build-date="${BUILD_DATE}" \
	org.label-schema.url="https://github.com/jc21/docker-mariadb-aria" \
	org.label-schema.vcs-url="https://github.com/jc21/docker-mariadb-aria.git" \
	org.label-schema.vcs-ref="${BUILD_COMMIT}" \
	org.label-schema.cmd="docker run -d jc21/mariadb-aria"

