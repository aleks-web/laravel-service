SHELL = /bin/bash
DC_RUN_ARGS = --rm --user "$(shell id -u):$(shell id -g)"
COMPOSE_TIMEOUT = 3000
.PHONY : help app-shell db-shell up up-build build down rebuild cleanup restart restart-quiet mysqlcheck pull patch
.DEFAULT_GOAL : help
#include .env
export

# This will output the help for each task. thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Помощь по Makefile
	@printf "\033[33m%s:\033[0m\n" 'Available commands'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "  \033[32m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


db-shell: ## Запуск консоли базы данных
	UNAME=$(shell whoami) docker-compose exec -it db_laravel bash

nginx-shell: ## Запуск консоли сервера nginx
	UNAME=$(shell whoami) docker-compose exec -it laravel_nginx bash

up: ## Поднять контейнера
	COMPOSE_HTTP_TIMEOUT=$(COMPOSE_TIMEOUT) UNAME=$(shell whoami) docker-compose up --detach --remove-orphans

down: ## Остановить контейнера
	UNAME=$(shell whoami) docker-compose down --remove-orphans --volumes

restart: down up ## Перезапустить контейнера

prune-volumes:
	docker volume prune -f

prune-image:
	docker image prune -f

prune-container:
	docker container prune -f

prune-system:
	docker system prune --all --volumes -f

prune-all: prune-container prune-image prune-volumes prune-system

app-shell: ## Консоль laravel
	UNAME=$(shell whoami) docker-compose exec -it php85 sh

app-migrate: ## Накатить миграции и сиды
	UNAME=$(shell whoami) docker-compose exec php85 php artisan migrate --seed

app-clear-cache: ## Очистка кеша приложения
	UNAME=$(shell whoami) cd laravel && php artisan cache:clear

app-route-list: ## Список роутов
	UNAME=$(shell whoami) docker-compose exec php85 php artisan route:list

chmod: ## Права на папки
	UNAME=$(shell whoami) docker-compose exec php85 sh -c 'chmod -R 777 storage/ && chmod -R 777 database/database.sqlite'

dev: ## Режим разработки
	UNAME=$(shell whoami) cd laravel && composer run dev

build: ## Собрать проект
	UNAME=$(shell whoami) cd laravel && npm run build

composer-install: ## composer install
	UNAME=$(shell whoami) docker-compose exec php85 composer install