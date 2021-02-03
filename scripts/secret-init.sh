#!/bin/sh

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
for VARNAME in $(declare -p | grep "^.*__FILE="); do
    log_note "[secret-init] evaluating ${VARNAME}"

    # set SECRETFILE to the contents of the variable
    # Use 'eval hack' for indirect expansion in sh: https://unix.stackexchange.com/questions/111618/indirect-variable-expansion-in-posix-as-done-in-bash
    # WARNING: It's not foolproof is an arbitrary command injection vulnerability 
    eval SECRETFILE="\${${VARNAME}}"

    log_note "[secret-init] setting SECRETFILE to ${SECRETFILE}"  # DEBUG
    
    # if SECRETFILE exists
    if [[ -f ${SECRETFILE} ]]; then
        # strip the appended "__FILE" from environmental variable name
        # and set value to contents of secretfile
        STRIPVAR=${VARNAME//__FILE/}
        # log_note "[secret-init] set STRIPVAR to ${STRIPVAR}"  # DEBUG
        eval ${STRIPVAR}=$(cat "${SECRETFILE}")
        export "${STRIPVAR}"
        # echo $(${STRIPVAR})

        log_note "[secret_init] set ${STRIPVAR} to $(eval echo \${${STRIPVAR}})"  # DEBUG
        log_note "[secret-init] ${STRIPVAR} set from ${VARNAME}"
    else
        log_error "[secret-init] cannot find secret in ${VARNAME}"
    fi
done
