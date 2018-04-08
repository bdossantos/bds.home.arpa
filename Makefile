CWD := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHELL := /usr/bin/env bash -e -u -o pipefail

help:
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

install: ## Install all the things
	DEBIAN_FRONTEND='noninteractive' run-parts -v $(CWD)/install.d

pre-commit: ## Run pre-commit tests
	$(info --> Run pre-commit)
	@pre-commit run --all-files

shellcheck: ## Run shellcheck on /scripts directory
	$(info --> Run shellsheck)
	find install.d -type f \
		| xargs -n 1 -P 1 -I % shellcheck %

test: ## Run tests suite
	$(MAKE) pre-commit shellcheck
