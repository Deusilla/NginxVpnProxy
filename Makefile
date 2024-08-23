include .env

COMPOSE=docker-compose -f docker-compose.yml
EXEC_PROXY=$(COMPOSE) exec proxy

.DEFAULT_GOAL := help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bash-proxy: ## Run bash (Proxy Nginx)
	$(EXEC_PROXY) bash

up: ## Up Docker-project
	$(COMPOSE) up -d --build --force-recreate

down: ## Down Docker-project
	$(COMPOSE) down --remove-orphans

stop: ## Stop Docker-project
	$(COMPOSE) stop

build: ## Build Docker-project
	$(COMPOSE) build --no-cache

default: help
