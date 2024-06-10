# Define variables
BIN_DIR := $(PWD)/bin
MC_URL := https://dl.min.io/client/mc/release/darwin-amd64/mc
MC_BIN := /usr/local/bin/mc
PROFILE_FILES := ~/.bashrc ~/.zshrc ~/.profile ~/.bash_profile

# Default target
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make install     Install all dependencies"
	@echo "  make start       Start the process"
	@echo "  make stop        Stop the process and teardown everything"

# Install dependencies
.PHONY: install
install: install-colima install-docker install-helm install-kubectl install-minikube install-mc update-path
	@echo "Dependencies installed successfully."
	@echo ""
	@echo "The Blobber CLI has been added to your PATH."
	@echo ""
	@echo "You can use the Blobber CLI with commands like:"
	@echo "  blobber create-bucket --name=my-bucket"
	@echo "  blobber upload --source=path/to/source --dest=my-bucket/path/to/dest"
	@echo "  blobber download --source=my-bucket/path/to/file --dest=path/to/file"
	@echo ""
	@echo "Sourcing profile files to apply changes..."
	@for profile in $(PROFILE_FILES); do \
		if [ -f $$profile ]; then \
			echo "Sourcing $$profile..."; \
			. $$profile; \
		fi \
	done
	@echo "Profile files sourced. You can now use the Blobber CLI."

install-colima:
	@if ! command -v colima >/dev/null 2>&1; then \
		echo "Installing Colima..."; \
		brew install colima; \
	else \
		echo "Colima is already installed."; \
	fi

install-docker:
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "Installing Docker..."; \
		brew install --cask docker; \
	else \
		echo "Docker is already installed."; \
	fi

install-helm:
	@if ! command -v helm >/dev/null 2>&1; then \
		echo "Installing Helm..."; \
		brew install helm; \
	else \
		echo "Helm is already installed."; \
	fi

install-kubectl:
	@if ! command -v kubectl >/dev/null 2>&1; then \
		echo "Installing kubectl..."; \
		brew install kubectl; \
	else \
		echo "kubectl is already installed."; \
	fi

install-minikube:
	@if ! command -v minikube >/dev/null 2>&1; then \
		echo "Installing Minikube..."; \
		brew install minikube; \
	else \
		echo "Minikube is already installed."; \
	fi

install-mc:
	@if ! [ -x "$(MC_BIN)" ]; then \
		echo "Installing MinIO client (mc)..."; \
		wget $(MC_URL) -O mc; \
		chmod +x mc; \
		sudo mv mc $(MC_BIN); \
	else \
		echo "MinIO client (mc) is already installed."; \
	fi

update-path:
	@for profile in $(PROFILE_FILES); do \
		if [ -f $$profile ]; then \
			if ! grep -q 'export PATH=$(BIN_DIR)' $$profile; then \
				echo "Adding $(BIN_DIR) to PATH in $$profile"; \
				echo 'export PATH=$$PATH:$(BIN_DIR)' >> $$profile; \
			else \
				echo "$(BIN_DIR) is already in PATH in $$profile"; \
			fi \
		fi \
	done

# Start the process
.PHONY: start
start:
	@echo "Starting Colima..."
	@colima start
	@echo "Starting Minikube..."
	@minikube start
	@echo "Starting MinIO and Traefik..."
	@kubectl apply -f manifests/namespace.yaml
	@kubectl apply -f manifests/minio-statefulset.yaml
	@kubectl apply -f manifests/minio-service.yaml
	@kubectl apply -f manifests/minio-ingressroute.yaml
	@echo "Starting port-forwarding for MinIO..."
	@kubectl port-forward svc/minio -n blobber 9000:9000 &
	@echo "MinIO is running at http://localhost:9000"

# Stop the process and teardown everything
.PHONY: stop
stop:
	@echo "Stopping port-forwarding..."
	@pkill -f "kubectl port-forward svc/minio -n blobber 9000:9000"
	@echo "Stopping Minikube..."
	@minikube stop
	@echo "Stopping Colima..."
	@colima stop
	@echo "Tearing down MinIO and Traefik..."
	@kubectl delete -f manifests/minio-ingressroute.yaml
	@kubectl delete -f manifests/minio-service.yaml
	@kubectl delete -f manifests/minio-statefulset.yaml
	@kubectl delete namespace blobber
	@echo "Process stopped and resources deleted."
