# Azure Finance Data Platform

## 1. Introduction
The Azure Finance Data Platform is a production-ready lakehouse blueprint for financial analytics. It combines Azure infrastructure, Databricks Unity Catalog, and medallion architecture best practices to deliver governed, testable, and automatable data products.

## 2. Architecture Overview
- Azure Resource Group hosting storage and Databricks workspace.
- ADLS Gen2 account with landing, bronze, silver, gold, and logs containers.
- Databricks Premium workspace integrated with Unity Catalog metastore, catalog, schemas, and external locations.
- Databricks Workflows orchestrating bronze ingestion, silver cleansing, gold aggregation, and fraud scoring notebooks.
- GitHub Actions pipelines for Terraform deployments and Databricks notebook promotion.

## 3. Repository Structure
```
azure-finance-data-platform/
├── README.md
├── .gitignore
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   └── modules/
│       ├── storage_account/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── databricks_workspace/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── unity_catalog/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
├── data_pipeline/
│   ├── notebooks/
│   │   ├── bronze_ingest.py
│   │   ├── silver_cleanse.py
│   │   ├── gold_aggregates.py
│   │   └── fraud_scoring.py
│   ├── libs/
│   │   ├── __init__.py
│   │   ├── quality_checks.py
│   │   └── utils.py
│   └── jobs/
│       └── daily_batch_job.json
├── tests/
│   ├── test_quality_checks.py
│   └── data/
│       └── sample_transactions.csv
├── cicd/
│   ├── terraform.yml
│   └── databricks-deploy.yml
└── docs/
    ├── architecture.md
    ├── data_model.md
    ├── governance.md
    └── runbook.md
```

## 4. Infrastructure as Code
Terraform deploys the resource group, ADLS Gen2 storage, Databricks Premium workspace, and Unity Catalog objects. Sensitive values such as service principal secrets are parameterized via variables and GitHub Action secrets.

## 5. Data Pipeline
PySpark notebooks implement the medallion lifecycle:
- **Bronze** – Auto Loader streaming ingestion from landing container to Delta tables.
- **Silver** – Schema enforcement, deduplication, and quality validation using helper libraries.
- **Gold** – Aggregated KPIs and fraud scoring persisted to curated tables.

## 6. Governance & Data Quality
Unity Catalog defines the `finance_analytics` catalog, bronze/silver/gold schemas, storage credentials, and external locations. Masking policy guidance is included within Terraform for sensitive data. Quality checks live in reusable Python libraries with pytest coverage.

## 7. CI/CD Automation
Two GitHub Actions workflows manage deployments:
- **terraform.yml** – Runs `terraform init/plan/apply` with Azure service principal credentials.
- **databricks-deploy.yml** – Executes pytest, configures the Databricks CLI, and syncs notebooks plus job definitions.

## 8. Getting Started
1. Copy `infra/terraform.tfvars.example` to `infra/terraform.tfvars` and populate environment-specific values.
2. Authenticate Azure CLI or provide service principal credentials for Terraform and Databricks provider.
3. Run Terraform commands from the `infra` folder to provision infrastructure.
4. Configure GitHub repository secrets (`ARM_*`, `DATABRICKS_HOST`, `DATABRICKS_TOKEN`).
5. Trigger the Databricks deployment workflow or run notebooks manually to validate the pipeline.

Refer to the `docs/` directory for detailed architecture diagrams, data model descriptions, governance strategy, and operational runbook.

## 9. Local Development Workflow
- Create a feature branch from the `work` branch for any change (e.g., `git checkout -b feature/update-readme`).
- Implement code or documentation updates and run `pytest -q` locally to validate the shared quality checks.
- Commit changes with descriptive messages and open a pull request targeting `work`.
- After peer review, merge into `work` and trigger the CI workflows to promote infrastructure or notebook updates.

## 10. Troubleshooting & Support
- **Terraform State Issues:** Re-run `terraform init -upgrade` and ensure the remote backend is reachable before planning/applying changes.
- **Databricks Authentication:** Verify `DATABRICKS_HOST` and `DATABRICKS_TOKEN` secrets are present and that the token has workspace admin permissions for Unity Catalog operations.
- **PySpark Environment:** Install `pyspark` in your local or CI Python environment (`pip install pyspark`) to execute the included unit tests successfully.
- For further assistance, review the `docs/runbook.md` guidance on rerunning failed jobs or backfilling historical data.
