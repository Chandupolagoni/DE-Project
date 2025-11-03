resource "databricks_metastore" "this" {
  name         = var.metastore_name
  storage_root = var.logs_container_url
  region       = var.metastore_region
  owner        = var.metastore_owner
}

resource "databricks_metastore_assignment" "workspace" {
  workspace_id = var.workspace_id
  metastore_id = databricks_metastore.this.id
}

resource "databricks_storage_credential" "sp" {
  name = "${var.metastore_name}-sp-cred"

  azure_service_principal {
    tenant_id     = var.tenant_id
    client_id     = var.service_principal_client_id
    client_secret = var.service_principal_secret
  }

  comment = "Service principal credential for Unity Catalog external locations"
  depends_on = [databricks_metastore_assignment.workspace]
}

resource "databricks_external_location" "landing" {
  name            = "landing"
  url             = var.landing_container_url
  credential_name = databricks_storage_credential.sp.name
  comment         = "Landing zone files"
}

resource "databricks_external_location" "bronze" {
  name            = "bronze"
  url             = var.bronze_container_url
  credential_name = databricks_storage_credential.sp.name
  comment         = "Bronze managed tables"
}

resource "databricks_external_location" "silver" {
  name            = "silver"
  url             = var.silver_container_url
  credential_name = databricks_storage_credential.sp.name
  comment         = "Silver managed tables"
}

resource "databricks_external_location" "gold" {
  name            = "gold"
  url             = var.gold_container_url
  credential_name = databricks_storage_credential.sp.name
  comment         = "Gold curated datasets"
}

resource "databricks_catalog" "finance" {
  name         = "finance_analytics"
  metastore_id = databricks_metastore.this.id
  comment      = "Finance analytics catalog"
  isolation_mode = "ISOLATED"
  properties = {
    purpose = "analytics"
  }
}

resource "databricks_schema" "bronze" {
  catalog_name = databricks_catalog.finance.name
  name         = "bronze"
  comment      = "Landing bronze schema"
}

resource "databricks_schema" "silver" {
  catalog_name = databricks_catalog.finance.name
  name         = "silver"
  comment      = "Cleansed silver schema"
}

resource "databricks_schema" "gold" {
  catalog_name = databricks_catalog.finance.name
  name         = "gold"
  comment      = "Curated gold schema"
}

# Example masking policy for PCI data (execute in Databricks SQL):
# CREATE MASKING POLICY finance_analytics.policies.mask_pan AS (val STRING) -> STRING RETURN
#   CASE
#     WHEN is_account_group_member('finance-analysts') THEN val
#     ELSE concat(repeat('*', length(val) - 4), right(val, 4))
#   END;
