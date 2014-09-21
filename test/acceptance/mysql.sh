#!/bin/bash

tag="$1"
cmd=""

case "$tag" in
	centos*)
		echo "centos"
		cmd="yum install dialog which -y && exec >/dev/tty 2>/dev/tty </dev/tty && ./bin/run"
		;;
esac

if [ -n "$cmd" ]; then
	sudo docker run -i -t -v $(pwd):/tmp/installer -w /tmp/installer -e APP_HOME=/tmp -e APP_SAFE_NAME=blank-noop-app -e APP_USER=nobody -e APP_GROUP=nobody -e APP_NAME=blank-noop-app -e INSTALLER_DIR=/tmp/installer -e ADDONS=mysql -e INSTALLER_DEBUG=yes "$tag" bash -c "$cmd ; bash"
fi
