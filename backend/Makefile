# Makefile

PROJECT_DEV_NAME=jobqa-dev
PROJECT_PROD_NAME=jobqa-prod

COMPOSE_DEV=./docker/docker-compose.dev.yml
COMPOSE_PROD=./docker/docker-compose.prod.yml

dev-build:
	docker-compose -p ${PROJECT_DEV_NAME} -f ${COMPOSE_DEV} up --build
prod-build:
	docker-compose -p ${PROJECT_PROD_NAME} -f ${COMPOSE_PROD} up --build

dev-up:
	docker-compose -p ${PROJECT_DEV_NAME} -f ${COMPOSE_DEV} up
prod-up:
	docker-compose -p ${PROJECT_PROD_NAME} -f ${COMPOSE_PROD} up

dev-down:
	docker-compose -p ${PROJECT_DEV_NAME} -f ${COMPOSE_DEV} down
prod-down:
	docker-compose -p ${PROJECT_PROD_NAME} -f ${COMPOSE_PROD} down


.PHONY:
	dev-build prod-build dev-up prod-up dev-down prod-down