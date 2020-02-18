.DEFAULT_GOAL := default

### Macro
%:
	@:


# BUILD & RUN
default: init start migrate-deferred

# Build application
init: vendor node_modules env app-compile ui-install

# Rebuild application
rebuild: vendor node_modules app-compile migrate-deferred

# Run application
start:
	docker-compose -f docker/docker-compose.yaml up -d

# Stop application
stop:
	docker-compose -f docker/docker-compose.yaml down



## Utilities
artisan:
	@docker-compose -f docker/docker-compose.yaml exec app ./artisan $(filter-out $@,$(MAKECMDGOALS))

composer:
	@docker run --rm -v $(shell pwd):/app -u 1000:1000 -w /app composer composer $(filter-out $@,$(MAKECMDGOALS))

yarn:
	@docker run --rm -v $(shell pwd):/app -u 1000:1000 -w /app node:10-alpine yarn $(filter-out $@,$(MAKECMDGOALS))

npm:
	@docker run --rm -v $(shell pwd):/app -u 1000:1000 -w /app node:10-alpine npm $(filter-out $@,$(MAKECMDGOALS))


docker-clear: docker-stop docker-rm docker-rmi



## sources
vendor: composer.json
	@make composer install

node_modules: package.json
	@make frontend-install

env:
	@[ -f ./.env ] && true || cp .env.example .env && make app-key

migrate-deferred:
	sleep 120 && docker-compose -f docker/docker-compose.yaml exec app ./artisan migrate:refresh --seed

frontend-install:
	@docker run --rm -v $(shell pwd):/app -u 1000:1000 -w /app node:10-alpine sh -c "npm rebuild node-sass --force && yarn install"

app-key:
	@docker run --rm -v $(shell pwd):/app -u 1000:1000 -w /app php:7.4-fpm-alpine sh -c "php artisan key:generate"

app-compile:
	@docker run --rm -v $(shell pwd):/app -u 1000:1000 -w /app php:7.4-fpm-alpine sh -c "php artisan cache:clear && php artisan clear-compiled && php artisan optimize:clear"

ui-install:
	@docker run --rm -v $(shell pwd):/app -u 1000:1000  -w /app composer require laravel/ui --dev

docker-stop:
	docker stop `docker ps -qa`

docker-rm:
	docker rm `docker ps -qa`

docker-rmi:
	docker rmi -f `docker images -qa `
