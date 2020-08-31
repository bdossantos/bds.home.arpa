CWD := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHELL := /usr/bin/env bash -e -u -o pipefail

help:
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

install: ## Install all the things
	@if [[ -z $CI ]]; then \
		pip install --user -r requirements.txt; \
	else \
		pip install -r requirements.txt; \
	fi

pre-commit: ## Run pre-commit tests
	$(info --> Run pre-commit)
	@pre-commit run --all-files

shellcheck: ## Run shellcheck on /scripts directory
	$(info --> Run shellsheck)
	find install.d -type f \
		| xargs -n 1 -P 1 -I % shellcheck %

test: ## Run tests suite
	$(MAKE) pre-commit
	docker build -t bdossantos/home-assistant .
	docker run \
		-v "${PWD}/homeassistant:/config" \
		-v '${PWD}/homeassistant/secrets.yaml.dist:/config/secrets.yaml:ro' \
		bdossantos/home-assistant:latest \
		python -m homeassistant --config /config --script check_config
