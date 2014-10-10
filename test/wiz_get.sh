#!/bin/bash -e

DIR=$(dirname "$0")
export INSTALLER_DEBUG="yes"
export DATABASE=$(mktemp)

. ${DIR}/assert.sh
. $(dirname "$DIR")/wizard

wiz_template() {
	echo "${DIR}/fixtures/templates"
}

test_failure() {
	wiz_get "mysql/doesnotexist"
}

test_value_with_space() {
	wiz_set "mysql/some-key" "some value"
	wiz_get "mysql/some-key"
}

test_value_without_space() {
	wiz_set "mysql/some-key" 'hello4$world'
	wiz_get "mysql/some-key"
}

assert_raises "test_failure" 1
assert "test_value_with_space" "some value"
assert "test_value_without_space" 'hello4$world'
assert_end "wiz_get"
