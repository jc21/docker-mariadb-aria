#!/bin/bash

# logic cribbed from linuxserver.io: 
# https://github.com/linuxserver/docker-baseimage-ubuntu/blob/bionic/root/etc/cont-init.d/01-envfile

# logging
logger() {
	local type="$1"; shift
	printf '%s [%s] %s\n' "$(date -R)" "$type" "$*"
}
log_note() {
	logger Note "$@"
}
log_warn() {
	logger Warn "$@" >&2
}
log_error() {
	logger ERROR "$@" >&2
	exit 1
}

function setenv() { export "$1=$2"; }

# log_note "$(compgen -e)"  # DEBUG

# iterate over environmental variables
# if variable ends in "__FILE"
for VARNAME in $(compgen -e | grep "__FILE$"); do
    log_note "[secret-init] evaluating ${VARNAME}"

    # set SECRETFILE to the contents of the variable
    SECRETFILE="${!VARNAME}"
    # log_note "[secret-init] setting SECRETFILE to ${SECRETFILE}"  # DEBUG
    
    # if SECRETFILE exists
    if [[ -f ${SECRETFILE} ]]; then
        # strip the appended "__FILE" from environmental variable name
        # and set value to contents of secretfile
        STRIPVAR=${VARNAME//__FILE/}
        # log_note "[secret-init] set STRIPVAR to ${STRIPVAR}"  # DEBUG
        declare ${STRIPVAR}=$(cat "${SECRETFILE}")
        export "${STRIPVAR}"
        # echo $(${STRIPVAR})

        log_note "[secret_init] set ${STRIPVAR} to ${!STRIPVAR}"  # DEBUG
        log_note "[secret-init] ${STRIPVAR} set from ${VARNAME}"
    else
        log_error "[secret-init] cannot find secret in ${VARNAME}"
    fi
done
