# Makefile for Azure Databricks Data Engineering Project

.PHONY: help install test lint format clean deploy-infra deploy-databricks run-pipeline

# Default target
help:
	@echo "Available targets:"
	@echo "  install          - Install Python dependencies"
	@echo "  test             - Run unit tests"
	@echo "  test-integration - Run integration tests"
	@echo "  lint             - Run linting checks"
	@echo "  format           - Format code with black"
	@echo "  clean            - Clean up temporary files"
	@echo "  deploy-infra     - Deploy Azure infrastructure"
	@echo "  deploy-databricks - Deploy Databricks configuration"
	@echo "  run-pipeline     - Run data pipeline"
	@echo "  setup-dev        - Setup development environment"

# Install dependencies
install:
	pip install -r config/requirements.txt

# Run unit tests
test:
	python -m pytest tests/unit/ -v --cov=src --cov-report=html --cov-report=term

# Run integration tests
test-integration:
	python -m pytest tests/integration/ -v

# Run all tests
test-all:
	python -m pytest tests/ -v --cov=src --cov-report=html --cov-report=term

# Lint code
lint:
	flake8 src/ tests/ scripts/
	mypy src/

# Format code
format:
	black src/ tests/ scripts/
	isort src/ tests/ scripts/

# Clean up
clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf build/
	rm -rf dist/
	rm -rf .coverage
	rm -rf htmlcov/
	rm -rf .pytest_cache/
	rm -rf .mypy_cache/

# Deploy infrastructure
deploy-infra:
	python scripts/deploy_infrastructure.py --action deploy

# Deploy Databricks configuration
deploy-databricks:
	python scripts/deploy_databricks.py --action deploy

# Run data pipeline
run-pipeline:
	python scripts/run_pipeline.py --stage all

# Setup development environment
setup-dev: install
	pre-commit install
	@echo "Development environment setup complete!"

# Validate configuration
validate-config:
	python -c "import yaml; yaml.safe_load(open('config/config.yaml'))"
	@echo "Configuration validation passed!"

# Check infrastructure status
check-infra:
	cd infrastructure && terraform output

# Destroy infrastructure (use with caution!)
destroy-infra:
	cd infrastructure && terraform destroy

# Run specific pipeline stage
run-ingestion:
	python scripts/run_pipeline.py --stage ingestion

run-transformation:
	python scripts/run_pipeline.py --stage transformation

run-quality:
	python scripts/run_pipeline.py --stage quality

# Documentation
docs:
	cd docs && make html

# Security scan
security-scan:
	bandit -r src/ -f json -o security-report.json

# Performance test
perf-test:
	python -m pytest tests/performance/ -v

# Docker commands (if using containers)
docker-build:
	docker build -t data-engineering .

docker-run:
	docker run -it data-engineering

# Azure CLI helpers
az-login:
	az login

az-set-subscription:
	az account set --subscription $(SUBSCRIPTION_ID)

# Databricks CLI helpers
dbx-configure:
	databricks configure --token

dbx-list-clusters:
	databricks clusters list

dbx-list-jobs:
	databricks jobs list

# Monitoring
check-logs:
	tail -f logs/pipeline.log

# Backup
backup:
	tar -czf backup-$(shell date +%Y%m%d).tar.gz config/ infrastructure/ src/

# Environment variables
export AZURE_SUBSCRIPTION_ID ?= $(shell az account show --query id -o tsv)
export AZURE_TENANT_ID ?= $(shell az account show --query tenantId -o tsv)

# Help for specific targets
help-deploy:
	@echo "Deployment targets:"
	@echo "  deploy-infra     - Deploy Azure infrastructure using Terraform"
	@echo "  deploy-databricks - Deploy Databricks notebooks and jobs"
	@echo "  run-pipeline     - Execute the complete data pipeline"

help-test:
	@echo "Testing targets:"
	@echo "  test             - Run unit tests with coverage"
	@echo "  test-integration - Run integration tests"
	@echo "  test-all         - Run all tests"
	@echo "  lint             - Run code linting"
	@echo "  format           - Format code with black and isort"

help-dev:
	@echo "Development targets:"
	@echo "  setup-dev        - Setup development environment"
	@echo "  clean            - Clean up temporary files"
	@echo "  validate-config  - Validate configuration files"
	@echo "  docs             - Generate documentation"
