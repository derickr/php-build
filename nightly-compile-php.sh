#!/bin/bash

WORKSPACE=/tmp/php-build/workspace
TREES=${WORKSPACE}/trees
INSTALL_DIR=${WORKSPACE}/install
LOGS=${WORKSPACE}/logs

mkdir -p ${TREES}
mkdir -p ${INSTALL_DIR}
mkdir -p ${LOGS}

# Figuring out where we are
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

DATE=`date  +%Y-%m-%d`
mkdir -p ${LOGS}/${DATE}

date
echo Start
for i in 7.2dev 7.3dev 7.4dev master; do
	GIT_DIR=${TREES}/nightly-${i}
	TARGET_DIR=${INSTALL_DIR}

	if [ ! -d ${GIT_DIR} ]; then
		git clone https://github.com/php/php-src.git ${GIT_DIR}
		cd ${GIT_DIR}
		if [ "$i" != "master" ]; then
			BRANCH=`echo $i | sed 's/\([0-9]\)\.\([0-9]\)dev/PHP-\1.\2/'`
			git checkout ${BRANCH}
		fi
	fi

	date
	echo Cleaning for $i
	cd ${GIT_DIR}
	git clean -xfd >> ${LOGS}/${DATE}/nightly-compile.log 2>&1
	git pull >> ${LOGS}/${DATE}/nightly-compile.log 2>&1

	date
	echo Building for $i
	${DIR}/build-variants.sh ${GIT_DIR} ${TARGET_DIR} $i
done

date
echo Done
