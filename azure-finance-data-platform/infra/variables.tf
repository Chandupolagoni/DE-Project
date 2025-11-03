variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus2"
}

variable "tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "azure-finance-data-platform"
  }
}

variable "storage_account_name" {
  description = "Storage account name for ADLS Gen2"
  type        = string
}

variable "storage_account_tier" {
  description = "Storage account performance tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "databricks_workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
}

variable "databricks_sku" {
  description = "Pricing tier for Databricks workspace"
  type        = string
  default     = "premium"
}

variable "databricks_sp_client_id" {
  description = "Service principal client ID used by Databricks provider"
  type        = string
}

variable "databricks_sp_client_secret" {
  description = "Service principal client secret used by Databricks provider"
  type        = string
  sensitive   = true
}

variable "unity_metastore_name" {
  description = "Name for the Unity Catalog metastore"
  type        = string
  default     = "finance-metastore"
}

variable "unity_metastore_owner" {
  description = "Owner for the Unity Catalog metastore"
  type        = string
  default     = "data.platform@contoso.com"
}
