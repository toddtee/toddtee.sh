SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

#Don't use tabs for block char, use '>' instead.
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

buildDev:
> hugo --cleanDestinationDir --config config-development.toml
.PHONY: buildDev

buildProd:
> hugo --cleanDestinationDir --config config-production.toml
.PHONY: buildProd

deployDev: buildDev
> hugo deploy --target development --config config-development.toml
.PHONY: deploy

deployProd: buildProd
> hugo deploy --target production --config config-production.toml
.PHONY: deploy

server:
> hugo server -D -F --config config-production.toml
.PHONY: server

