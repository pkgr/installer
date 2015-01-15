#!/bin/bash

BRANCH=${BRANCH:="master"}

set -ex

addons="mysql apache2 smtp svn-dav memcached openproject"
for addon in $addons ; do
  rm -rf addons/$addon
  git clone https://github.com/pkgr/addon-$addon --branch ${BRANCH} addons/$addon
done
