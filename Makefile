CWD := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PATH := $(HOME)/.local/bin:$(CWD)/bin:$(PATH)
SHELL := /usr/bin/env bash -e -u -o pipefail

help:
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

install: ## Install all the things
	@if [[ -z $CI ]]; then \
		pip3 install --user -r requirements.txt; \
	else \
		pip3 install -r requirements.txt; \
	fi

install-dyson: ## Install Dyson custom integration
	$(info --> Installing Dyson custom integration)
	@./scripts/install-dyson-integration.sh

build: ## Build Docker image
	$(info --> Building Docker image)
	docker build -t bdossantos/home-assistant .

up: ## Start Home Assistant container
	$(info --> Starting Home Assistant)
	docker-compose up -d

down: ## Stop Home Assistant container
	$(info --> Stopping Home Assistant)
	docker-compose down

logs: ## Show Home Assistant logs
	$(info --> Showing Home Assistant logs)
	docker-compose logs -f home-assistant

pre-commit: ## Run pre-commit tests
	$(info --> Run pre-commit)
	@pre-commit run --all-files

shellcheck: ## Run shellcheck on /scripts directory
	$(info --> Run shellsheck)
	find install.d -type f \
		| xargs -n 1 -P 1 -I % shellcheck %

test: ## Run tests suite
	$(MAKE) pre-commit
	$(MAKE) build
	docker run \
		-v "${PWD}/homeassistant:/config" \
		-v '${PWD}/homeassistant/secrets.yaml.dist:/config/secrets.yaml:ro' \
		bdossantos/home-assistant:latest \
		python -m homeassistant --config /config --script check_config
