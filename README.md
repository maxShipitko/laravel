# Laravel 6 with Laravel UI

You really shouldn't have a LEMP locally.
Just start local development in the fastest way.

## What's inside

- Laravel 6
- The Bootstrap and Vue scaffolding
- docker server in `/docker` folder
- Makefile as easy command interface

## Base docker images

- php:7.4-fpm-alpine
- node:10-alpine
- redis:5-alpine
- mariadb
- composer:latest

## Quick start

1. First you must have the Docker and the Docker Compose
    - [Docker instalation](https://docs.docker.com/install/)
    - [Docker Compose instalation](https://docs.docker.com/compose/install/)

2. Just build & run & have fun by ```make``` command
3. Your application will be run on http://localhost:8000

## Application management

- `make init` - initial build
- `make rebuild` - reinstall dependencies
- `make start` - start your application
- `make stop`  - stop your application

## Some usefull commands

- `artisan` - run **artisan cli** for runtime app
```
make artisan migrate
```
- `composer` - run dockerized **composer**
```
make composer dump-autoload
```
- `yarn` - run dockerized **yarn**
```
make yarn install
```
- `npm` - run dockerized **npm**
```
make npm install
```
- `docker-clear` - remove **all** containers and images


## What else

You can use containers and services manually:
```
docker-compose -f docker/docker-compose.yaml exec app ./artisan cache:clear
docker run --rm -v $( pwd):/app -u $(id -u):$(id -g) -w /app node:10-alpine yarn install
docker run --rm -v $(pwd):/app -u 1000:1000 -w /app composer composer install
```
