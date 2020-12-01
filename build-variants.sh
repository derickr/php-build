#!/bin/bash

WORKSPACE=/tmp/php-build/workspace
LOGS=${WORKSPACE}/logs

mkdir -p ${LOGS}

# Figuring out where we are
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

# Setting directories
TARGET_PREFIX_DIR=/usr/local/php

# If first argument is an existing directory, use it as GIT checkout directory
if [[ -d $1 ]]; then
	GIT_DIR=$1
	shift

	# If the next argument is also a directory, use it as target install directory
	if [[ -d $1 ]]; then
		TARGET_PREFIX_DIR=$1
		shift
	fi
else
	GIT_DIR=/home/derick/dev/php/php-src.git
fi
VERSION=$1


DATE=`date  +%Y-%m-%d`
mkdir -p ${LOGS}/${DATE}

${DIR}/build ${GIT_DIR} ${TARGET_PREFIX_DIR} ${VERSION} debug nozts 32bit >/${LOGS}/${DATE}/${VERSION}-32bit.log 2>&1
${DIR}/build ${GIT_DIR} ${TARGET_PREFIX_DIR} ${VERSION} debug zts >/${LOGS}/${DATE}/${VERSION}-zts.log 2>&1
${DIR}/build ${GIT_DIR} ${TARGET_PREFIX_DIR} ${VERSION} >/${LOGS}/${DATE}/${VERSION}.log 2>&1
