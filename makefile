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
> hugo --cleanDestinationDir --environment development
.PHONY: buildDev

buildProd:
> hugo --cleanDestinationDir
.PHONY: buildProd

deployDev: buildDev
> hugo deploy --environment development
.PHONY: deploy

deployProd: buildProd
> hugo deploy --environment production
.PHONY: deploy

server:
> hugo server -D -F
.PHONY: server

