output "resource_group_name" {
  description = "Provisioned resource group name"
  value       = azurerm_resource_group.this.name
}

output "storage_account_name" {
  description = "Name of the ADLS Gen2 storage account"
  value       = module.storage_account.name
}

output "databricks_workspace_url" {
  description = "URL of the Databricks workspace"
  value       = module.databricks_workspace.workspace_url
}

output "unity_catalog_metastore_id" {
  description = "Unity Catalog metastore ID"
  value       = module.unity_catalog.metastore_id
}
