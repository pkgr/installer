#!/bin/bash

set -e

yum check-update &>/dev/null || true

yum -y install \
  sudo \
  wget \
  curl

yum install -y dialog which

( grep "cd /installer" /home/vagrant/.bash_profile ) || ( echo "cd /installer" >> /home/vagrant/.bash_profile )
echo "nameserver 8.8.8.8
nameserver 4.4.4.4" > /etc/resolv.conf
