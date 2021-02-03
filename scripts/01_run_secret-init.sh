#!/bin/sh

# call secret-init from bash instead of sh
bash /scripts/secret-init.bash

# force export variables to running process
# if [ -z ${VARIABLE:?default} ];
