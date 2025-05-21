# Variables
IMAGE_NAME=broken-link-checker
PYTHON=python3
VENV=venv
SCRIPT=brokenLinks.py

# 📦 Full reset & run: clean, pull, venv, Docker build/run, local exec
.PHONY: all
all: clean pull venv build run local

# 🔄 Pull latest code from current Git branch
.PHONY: pull
pull:
	git pull 
# else use => git pull origin $$(git rev-parse --abbrev-ref HEAD)

# 🧹 Remove existing Docker image
.PHONY: clean
clean:
	@echo "Cleaning up existing Docker image (if any)..."
	@docker image inspect $(IMAGE_NAME) > /dev/null 2>&1 && docker rmi -f $(IMAGE_NAME) || echo "No existing image to remove."

# 🐍 Set up virtual environment and install dependencies
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

# 🐳 Build Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

# 🚀 Run Docker container
.PHONY: run
run:
	docker run --rm $(IMAGE_NAME)

# 🧪 Run script locally using venv
.PHONY: local
local:
	$(VENV)/bin/python $(SCRIPT)

# 🐚 Open Docker container shell (optional)
.PHONY: shell
shell:
	docker run --rm -it $(IMAGE_NAME) /bin/bash