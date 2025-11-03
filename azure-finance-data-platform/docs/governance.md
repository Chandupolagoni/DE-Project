# Governance and Masking Strategy

## Unity Catalog Governance
- **Metastore Ownership**: Assigned to the data platform team for centralized controls.
- **Catalog-Level Permissions**: `finance_analytics` catalog grants usage to finance analytics group, admin privileges to platform engineering.
- **Schema Permissions**:
  - `bronze`: restricted writes to ingestion service principals; read-only for data engineers.
  - `silver`: write access for data engineering; read for analytics.
  - `gold`: read access for BI, data science, and compliance personas.
- **External Locations**: Provisioned with Azure AD service principal credentials to ensure storage access is consistent across workspaces.

## Masking and Data Privacy
- **Masking Policy**: Example policy masks PAN values unless a user is in the approved analyst group.
- **Row-Level Filtering**: Apply `GRANT SELECT` with dynamic views to restrict country- or business-unit-specific data.
- **Column-Level Security**: Sensitive attributes (PAN, CVV, SSN) remain in bronze/silver with restricted view-based access.

## Operational Controls
- **Audit Logging**: Unity Catalog automatically logs access to Delta tables stored in gold and silver layers.
- **Secrets Management**: Service principal secrets stored in GitHub Actions secrets and Terraform variables, never in source code.
- **Change Management**: Infrastructure changes via Terraform workflow, data pipeline changes via Databricks workflow with tests.
