#!/bin/bash

OS = $(shell uname)
UID = $(shell id -u)
DOCKER_BE = docker-dev-env-for-symfony-be

help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

start: ## Start the containers
	docker network create docker-dev-env-for-symfony-network || true
	cp -n docker-compose.yml.dist docker-compose.yml || true
	cp -n .env.dist .env || true
	U_ID=${UID} docker-compose up -d

stop: ## Stop the containers
	U_ID=${UID} docker-compose stop

restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) start

build: ## Rebuilds all the containers
	docker network create docker-dev-env-for-symfony-network || true
	cp -n docker-compose.yml.dist docker-compose.yml || true
	cp -n .env.dist .env || true
	U_ID=${UID} docker-compose build

prepare: ## Runs backend commands
	$(MAKE) composer-install
	$(MAKE) migrations

run: ## starts the Symfony development server
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} symfony serve -d

# Backend commands
composer-install: ## Installs composer dependencies
	U_ID=${UID} docker exec --user ${UID} ${DOCKER_BE} composer install --no-interaction

migrations: ## Installs composer dependencies
	U_ID=${UID} docker exec --user ${UID} ${DOCKER_BE} bin/console doctrine:migration:migrate -n --allow-no-migration

logs: ## Show Symfony logs in real time
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} symfony server:log
	
# End backend commands

ssh-be: ## bash into the be container
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} bash

code-style: ## Runs php-cs to fix code styling following Symfony rules
	U_ID=${UID} docker exec --user ${UID} ${DOCKER_BE} php-cs-fixer fix src --rules=@Symfony

# .PHONY: migrations

