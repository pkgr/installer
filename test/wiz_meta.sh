#!/bin/bash -e

DIR=$(dirname "$0")
export DATABASE=$(mktemp)

. ${DIR}/assert.sh
. $(dirname "$DIR")/wizard

wiz_template() {
	echo "${DIR}/fixtures/templates"
}

test_type() {
	echo $(wiz_meta "mysql/autoinstall" "type")
}

test_title() {
	echo $(wiz_meta "mysql/autoinstall" "title")
}

test_default() {
	echo $(wiz_meta "mysql/autoinstall" "default")
}

test_description() {
	echo $(wiz_meta "mysql/autoinstall" "description")
}

test_choices() {
	echo $(wiz_meta "mysql/autoinstall" "choices")
}

assert "test_type" "select"
assert "test_title" "Do you want to use this wizard to help setup your MySQL database?"
assert "test_default" "skip"
assert "test_description" "If you want, we can automatically create the MySQL database required by _APP_NAME_.\\\n\\\nIf you choose NOT to use this wizard, you will have to manually setup all the things related to the database."
assert "test_choices" '"skip" "Skip this wizard altogether" "use an existing database" "Use an existing MySQL database" "create a new database" "Create a new database (requires MySQL superuser password)"'

# template can be different depending on the current value
wiz_set "mysql/autoinstall" "use an existing database"
assert "test_type" "select"
assert "test_title" "Do you want to keep your existing database?"
assert "test_default" "use an existing database"
assert "test_description" "You previously chose to use your existing MySQL database.\\\n\\\nIf you want, we can automatically create the MySQL database required by _APP_NAME_.\\\n\\\nIf you choose NOT to use this wizard, you will have to manually setup all the things related to the database."
assert "test_choices" '"skip" "Skip this wizard altogether" "use an existing database" "Keep existing MySQL database" "create a new database" "Create a new database (requires MySQL superuser password)"'

assert_end "wiz_meta"
