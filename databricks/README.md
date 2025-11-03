# Databricks Asset Bundle

This directory contains the Databricks Asset Bundle configuration that enables
repeatable CI/CD deployments for the Azure Databricks data engineering project.

## Contents

- `bundle.yml` – Declarative specification of jobs, files and environment
targets that make up the bundle.
- `jobs/run_pipeline.py` – Python entry point executed by the bundle controlled
job.
- `notebooks/` – Example notebooks packaged with the bundle to represent the
Bronze → Silver → Gold transformations.

## Usage

1. **Configure the Databricks CLI** with a [personal access token or service
   principal](https://docs.databricks.com/en/dev-tools/cli/index.html).
2. **Select a target environment** (for example `dev` or `prod`) via the
   `--environment` flag.
3. **Deploy the bundle**:

   ```bash
   databricks bundle deploy --target dev
   ```

4. **Run the defined workflow**:

   ```bash
   databricks bundle run cicd_pipeline --target dev
   ```

The bundle uses environment variables documented inside `bundle.yml` to
parameterise cluster sizes, workspace roots and principals.

## CI/CD Integration

The bundle file is designed to be executed from a CI workflow.  The workflow
should perform the following steps:

1. Install the Databricks CLI (version >= 0.205).
2. Authenticate using a workload identity or service principal.
3. Run `databricks bundle validate --target dev` during pull requests to ensure
   configuration consistency.
4. Run `databricks bundle deploy --target prod` on the main branch after
   automated testing passes.

## Customisation

- Update `config/dev-config.yaml` and `config/prod-config.yaml` with environment
  specific storage paths, quality settings and notification groups.
- Replace the placeholder notebooks with the actual transformation logic.
- Extend `jobs/run_pipeline.py` to call project specific modules or workflows
  once they are available in the repository.
