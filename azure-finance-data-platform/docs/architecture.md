# Azure Finance Data Platform Architecture

## Overview
The Azure Finance Data Platform delivers an end-to-end medallion architecture for financial analytics with Azure-native services and Databricks Unity Catalog. The solution enables governed ingestion, scalable processing, and governed consumption for analysts and data scientists.

## Core Components
- **Azure Resource Group** – container for all platform resources.
- **Azure Data Lake Storage Gen2** – centralized lakehouse storage with landing, bronze, silver, gold, and logs containers.
- **Azure Databricks Premium Workspace** – collaborative analytics and job execution environment with Unity Catalog.
- **Unity Catalog Metastore** – centralized governance layer with catalog, schemas, storage credentials, and external locations.
- **Databricks Workflows** – orchestrate notebook-based pipelines for ingestion, cleansing, enrichment, and fraud analytics.
- **GitHub Actions** – CI/CD pipelines for Terraform infrastructure and Databricks assets.

## Data Flow
1. Raw files land in the **landing** container via batch or streaming sources.
2. Auto Loader streams data into **bronze** Delta tables while preserving original structure and metadata.
3. Silver notebooks cleanse, standardize, and validate data with custom quality checks.
4. Gold notebooks aggregate business metrics and publish analytics-ready tables.
5. Fraud scoring enriches gold outputs with machine learning predictions stored back in the gold layer.
6. Unity Catalog enforces storage credentials, external locations, and schemas for each layer, ensuring secure access.

## Networking & Security
- Storage secured via Azure AD service principal credentials configured in Unity Catalog.
- Workspace integrates with the metastore to enforce data access governance.
- GitHub Action secrets store sensitive credentials; Terraform variables parameterize environment-specific values.
