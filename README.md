# Installer wizard

This repository hosts the code used to generate wizards when using the installer feature of [Packager.io](https://packager.io).

## How it works

The design is inspired from the debconf tool, used on debian-based systems, but works on all distributions supported by Packager.io (Debian, Ubuntu, CentOS, RHEL, Fedora, SUSE).

It is a simple collection of bash scripts used to iteratively launch the `configure`, `preinstall`, and `postinstall` steps of wizard **addons**.

Addons do what's needed to configure and install specific system depencies for the package that is currently being configured. For instance, a GitLab package may use an installer that depends on an `apache2` and `mysql` wizard addons.

The installer provides shell functions that abstract the setting/retrieval of configuration entries, and also displays interactive questions to the user.

## Environment variables of note

* `CURRENT_ADDON`: folder name of the current addon being executed.
* `WIZ_RECONFIGURE`: if set to `yes`, all questions will be asked, whether they have already been answered or not.
* `INSTALLER_DEBUG`: if set to `yes`, all debug messages will be output on STDERR.

## Main functions

### `wizard`

Entry point of the installer wizard. Will call a `state_machine` function with the given argument (the starting "state"). The `state_machine` function must be defined in your addon, and must return 0 when the current state has been completed, as well as setting the next state to call using the global `STATE` environment variable.

Going back between states is automatically handled by the `wizard` function.

```bash
wizard "ask_for_db_info"
```

### `wiz_ask`

Asks all the questions in the queue, delegating to `wiz_dialog` for each type of question.
Returns 1 if `wiz_dialog` fails (i.e. the user chooses to "Exit" the question, or goes back).

```bash
if wiz_ask ; then
  # proceed to next set of questions
else
  # ask previous set of questions
fi
```

### `wiz_check_package`

Checks whether a given package already exists on the system. Handles .deb and .rpm based systems.

Returns 0 if the package is already installed.
Returns 1 if the package does not exist.

```bash
if wiz_check_package "mysql-server" ; then
	# proceed with database creation
else
	apt-get install mysql-server -y
fi
```

### `wiz_clear`

Clears the buffer of questions to be asked. Mostly for internal use.

```bash
wiz_clear
```

### `wiz_debug`

Will output the given message on STDERR if `INSTALLER_DEBUG` is set to `yes`.

```bash
wiz_debug "some message here"
```

### `wiz_dialog`

Triggers the display of a new dialog box for a specific question.
Questions are defined in a `templates` file at the root of each addon.
The user answer will be stored in the database using `wiz_set`.

Returns 0 if the user's answer has been correctly stored.<br>
Returns non-zero code if the user chooses to exit or cancel.<br>
Returns non-zero code if the dialog type is unknown.<br>

Supports the following dialog types:

* select (menu)
* string (text field)
* password (password field)
* boolean (yes/no question)

```bash
wiz_dialog "mysql/db_host"
```

### `wiz_fact`

Returns facts about the underlying OS.

Supported facts:

* `osfamily`: returns the system's s family (`debian`, `redhat`, `suse`).

```bash
wiz_fact "osfamily" # => debian
```

### `wiz_get`

Fetch the answer currently stored for a given question.
Returns 0 if a value exists (including empty strings), and outputs it on STDOUT.
Returns 1 if no value has been set yet.

```bash
if wiz_get "mysql/db_host" ; then
	db_host="$(wiz_get "mysql/db_host")"
	# do something with it
else
	# mysql/db_host is not set
fi
```

### `wiz_meta`

Fetch a question's property from the corresponding `templates` file.
Outputs the result on STDOUT.

```bash
wiz_meta "mysql/db_host" "description" # => MySQL IP or hostname
wiz_meta "mysql/db_host" "default" # => 127.0.0.1
wiz_meta "mysql/db_host" "type" # => string
```

### `wiz_put`

Adds a question to the buffer of questions to be asked.
The question itself will be displayed to the user when `wiz_ask` is called.

A question will be displayed to the user if and only if:

* `WIZ_RECONFIGURE` is set to `yes`, or
* the question has not been answered yet, or
* the question has been marked as "unseen", using `wiz_unseen` method.

### `wiz_random_password`

Generates a random password. Defaults to 32 characters long.

```bash
wiz_random_password 64 # => generates a 64 character random string
```

### `wiz_set`

Sets a configuration variable in the database. Always suceeds, unless the database file is absent.

```bash
wiz_set "key" "value"
```

### `wiz_template`

Returns the path to the current addon's `templates` file.

```bash
wiz_template # => mysql/templates
```

### `wiz_unseen`

Manually sets the given question as unseen, meaning it will be displayed to the user even if it has already been answered.

```bash
wiz_unseen "mysql/db_host"
```

## Helper functions

### `wiz_join`

Helper function to join multiple strings, using a custom delimiter.

```bash
wiz_join ", " a b c d # => a, b, c, d
```

### `wiz_urlencode`

Helper function used to URL encode a given string.

```bash
wiz_urlencode "mysql://user:pass@host:port/dbname?hello=world"
```

## Available addons

* https://github.com/pkgr/addon-rails4 - General addon for Rails4 apps.
* https://github.com/pkgr/addon-mysql - Addon for configuring a MySQL server and database.
* https://github.com/pkgr/addon-smtp - Addon for configuring SMTP settings or sendmail.
* https://github.com/pkgr/addon-memcached - Addon for setting up a memcached server.
* https://github.com/pkgr/addon-apache2 - Addon for setting up an Apache2 server, including SSL.
