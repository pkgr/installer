#!/bin/bash

set -ex

addons="mysql apache2 smtp svn-dav memcached"
for addon in $addons ; do
  rm -rf addons/$addon
  git clone https://github.com/pkgr/addon-$addon --branch installer addons/$addon
done
