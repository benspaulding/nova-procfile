#!/usr/bin/env -S just --justfile

# Config
# ======================================================================

set dotenv-load := true
set ignore-comments := true
set shell := ["fish", "-c"]

# Short names for commonly used functions
FROM := invocation_directory()
HERE := justfile_directory()
SELF := justfile()
SHEL := `test -n "$0" && echo "$0" || basename "$(status fish-path)"`

# Export more explicit names for other scripts to use
export JUST_RUN_PATH := FROM
export JUST_SRC_PATH := HERE
export JUSTFILE := SELF
export JUST_SHELLISH := SHEL

# Handy bits
t := "true"
f := "false"

src_dir := HERE / "src"
ext_dir := HERE / "Procfile.novaextension"

node_dir := HERE / "node_modules"
node_bin := node_dir / ".bin"

venv_dir := env_var_or_default("VIRTUAL_ENV", HERE / ".venv")
venv_bin := venv_dir / "bin"
venv_cfg := venv_dir / "pyvenv.cfg"
venv_act := venv_bin / "activate" + if SHEL =~ '^(fi|c)sh$' { "." + SHEL } else { "" }

pyexe := venv_bin / "python"

export NODE_ENV := env_var_or_default("NODE_ENV", "development")
export PATH := node_bin + ":" + venv_bin + ":" + env_var("PATH")


# Aliases
# ======================================================================

alias h := help
alias i := setup


# Recipes
# ======================================================================

## General
## ---------------------------------------------------------------------

# run this recipe if no arguments are given (by virtue of it being the *first* recipe)
@_default: ls

# list available recipes
@ls:
	"{{ SELF }}" --list --unsorted

# print help info & list available recipes
@help: && ls
	"{{ SELF }}" --help


## Setup
## ---------------------------------------------------------------------

# prep for development
setup: setup-node setup-venv
	git status

# prep node environment
setup-node:
	npm install

# prep python virtual environment
setup-venv:
	#!/usr/bin/env fish
	test -e "{{ venv_cfg }}"
	or python -m venv .venv
	and source "{{ venv_act }}"
	and "{{ venv_bin / 'python' }}" -m pip install -U --upgrade-strategy=eager pip setuptools wheel
	and "{{ venv_bin / 'python' }}" -m pip install pre-commit==3.6.2
	and "{{ venv_bin / 'pre-commit' }}" install --install-hooks


## Build
## ---------------------------------------------------------------------

# build the extension
build: build-dist build-lint build-fmt
	#!/usr/bin/env fish
	mkdir -p "{{ ext_dir }}"
	for file in {README,CHANGELOG}.md LICENSE.txt
		cp $file "{{ ext_dir }}"/
	end
	cp -r "{{ src_dir }}"/* "{{ ext_dir }}"/

# build extension javascript
build-dist:
	npm run compile

# lint all files
build-lint:
	npm run lint
	source "{{ venv_act }}" && pre-commit run -a

# format all files
build-fmt:
	npm run format


## Clean
## ---------------------------------------------------------------------

# remove development artifacts
clean: clean-dist clean-node clean-venv

# remove built extension files
clean-dist:
	rm -rf "{{ ext_dir }}"

# un-setup node environment
clean-node:
	rm -rf "{{ node_dir }}"

# un-setup python virtual environment
clean-venv:
	#!/usr/bin/env fish
	if test -e "{{ venv_cfg }}"
		source "{{ venv_act }}"
		if command -q pre-commit
			pre-commit clean
			pre-commit gc
			pre-commit uninstall
		end
		deactivate
	end
	rm -rf "{{ venv_dir }}"


## Develop
## ---------------------------------------------------------------------

# watch & build typescript files
watch:
	npm run watch
