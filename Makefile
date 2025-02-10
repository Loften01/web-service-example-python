# Variables
IMAGE_NAME ?= web-service-example
CONTAINER_NAME ?= web-service-example-app
DOCKERFILE_PATH ?= docker/server/Dockerfile
DOCKER_COMPOSE_PATH ?= docker/server/docker-compose.yml
CONFIG_PATH ?= config/production.yaml

# Targets
.PHONY: help install uninstall run stop restart run-ci

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  help         - Show this help message"
	@echo "  install      - Pull latest changes and build Docker image"
	@echo "  uninstall    - Stop and remove Docker containers"
	@echo "  run          - Run the container in production mode"
	@echo "  stop         - Stop the running container"
	@echo "  restart      - Restart the container in production mode"
	@echo "  run-ci       - Run CI checks (ruff, mypy, poetry, pip)"

install:
	@echo "Pulling latest changes from git..."
	git pull
	@echo "Building Docker image..."
	docker compose -f ${DOCKER_COMPOSE_PATH} build

uninstall:
	@echo "Stopping and removing Docker containers..."
	docker compose -f ${DOCKER_COMPOSE_PATH} down
	docker system prune -f

run:
	@echo "Running the container in production mode..."
	IMAGE_NAME=${IMAGE_NAME} CONTAINER_NAME=${CONTAINER_NAME} DOCKERFILE_PATH=${DOCKERFILE_PATH} CONFIG_PATH=${CONFIG_PATH} docker compose -f ${DOCKER_COMPOSE_PATH} up --remove-orphans -d

stop:
	@echo "Stopping the container..."
	docker compose -f ${DOCKER_COMPOSE_PATH} stop

restart:
	@echo "Restarting the container in production mode..."
	docker compose -f ${DOCKER_COMPOSE_PATH} restart

run-ci:
	@echo "Running CI checks..."
	ruff check . --output-format concise
	mypy server
	poetry check
	@echo "CI finished!"
