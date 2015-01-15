#!/bin/bash

set -e

echo "nameserver 8.8.8.8
nameserver 4.4.4.4" > /etc/resolv.conf

zypper ar --no-gpgcheck -t yast2 "http://storage.googleapis.com/pkgr-io-cache/SLE-12-Server-DVD-x86_64-GM-DVD1" "SLES12 Server DVD1"
zypper ar --no-gpgcheck -t yast2 "http://storage.googleapis.com/pkgr-io-cache/SLE-12-SDK-DVD-x86_64-GM-DVD1" "SLES12 SDK DVD1"
zypper ar --no-gpgcheck -t yast2 "http://storage.googleapis.com/pkgr-io-cache/SLE-12-HA-DVD-x86_64-GM-CD1" "SLES12 HA CD1"

zypper install -y dialog which
zypper install -y git-core

( grep "cd /installer" /home/vagrant/.bash_profile ) || ( echo "cd /installer" >> /home/vagrant/.bash_profile )
echo "DONE"
