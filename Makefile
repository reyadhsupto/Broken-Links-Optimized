# Variables
IMAGE_NAME=broken-link-checker
PYTHON=python3
VENV=venv
SCRIPT=brokenLinks.py
URL ?= https://www.amazon.com/

# Full reset & run: clean, pull, venv, Docker build/run, local exec
.PHONY: all
all: clean pull venv build run local

# Pull latest code from current Git branch
.PHONY: pull
pull:
	@echo "Pulling latest codebase"
	git pull 
# else use => git pull origin $$(git rev-parse --abbrev-ref HEAD)

# Remove existing Docker image
.PHONY: clean
clean:
	@echo "Cleaning up existing Docker image (if any)..."
	@docker image inspect $(IMAGE_NAME) > /dev/null 2>&1 && docker rmi -f $(IMAGE_NAME) || echo "No existing image to remove."

# Set up virtual environment and install dependencies
.PHONY: venv
venv:
	@if [ ! -d "$(VENV)" ]; then \
		echo "Creating virtual environment..."; \
		$(PYTHON) -m venv $(VENV); \
	else \
		echo "Virtual environment already exists."; \
	fi
	$(VENV)/bin/pip install --upgrade pip
	$(VENV)/bin/pip install -r requirements.txt
	$(VENV)/bin/python -m playwright install

# Build Docker image
.PHONY: build
build:
	@echo "Building docker image"
	docker build -t $(IMAGE_NAME) .

# Run Docker container
.PHONY: run
run:
	@echo "Running docker image"
	docker run --rm $(IMAGE_NAME) $(URL)

# Run script locally using venv
.PHONY: local
local:
	@echo "Executing script to collect links"
	$(VENV)/bin/python $(SCRIPT) $(URL)

# Open Docker container shell (optional)
.PHONY: shell
shell:
	@echo "Opening Docker container shell"
	docker run --rm -it $(IMAGE_NAME) /bin/bash

# Help
.PHONY: help
help:
	@echo "Makefile commands:"
	@echo "  make pull         - Pull the updated codebase"
	@echo "  make venv   	   - Create environment file"
	@echo "  make build        - Build Docker image"
	@echo "  make run          - Run the project"
	@echo "  make clean        - Clean up all Docker resources"
	@echo "  make shell        - Opening Docker container shell"
	@echo "  make local        - Executing scripts locally"
	@echo "  make all          - clean, pull, venv, Docker build/run, local exec"
	@echo "  make <command> URL=<url>          - Explicitly specify url"