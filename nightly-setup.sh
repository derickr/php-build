#!/bin/bash

WORKSPACE=/tmp/php-build/workspace
TREES=${WORKSPACE}/trees

mkdir -p ${TREES}

for i in PHP-7.4 master; do
	git clone https://github.com/php/php-src.git ${TREES}/nightly-$i
	cd ${TREES}/nightly-$i
	git checkout $i
	cd -
done
