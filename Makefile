include .env

COMPOSE=docker-compose -f docker-compose.yml
EXEC_PROXY=$(COMPOSE) exec proxy
EXEC_NGINX=$(COMPOSE) exec nginx

.DEFAULT_GOAL := help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bash-proxy: ## Run bash (Proxy Nginx)
	$(EXEC_PROXY) bash

up: ## Up Docker-project
	$(COMPOSE) up -d --build --force-recreate

init:
	$(COMPOSE) exec proxy certbot --nginx --non-interactive --agree-tos -m webmaster@apptune.ru -d apptune.ru
	$(COMPOSE) exec proxy certbot --nginx --non-interactive --agree-tos -m webmaster@apptune.ru -d vpn.apptune.ru
	$(COMPOSE) exec proxy nginx -s reload

down: ## Down Docker-project
	$(COMPOSE) down --remove-orphans

stop: ## Stop Docker-project
	$(COMPOSE) stop

build: ## Build Docker-project
	$(COMPOSE) build --no-cache

ngx-stop: ## Send stop signal
	$(EXEC_PROXY) nginx -s stop

ngx-quit: ## Send quit signal
	$(EXEC_PROXY) nginx -s quit

ngx-reload: ## Send reload signal
	$(EXEC_PROXY) nginx -s reload

ngx-reopen: ## Send reopen signal
	$(EXEC_PROXY) nginx -s reopen

default: help
