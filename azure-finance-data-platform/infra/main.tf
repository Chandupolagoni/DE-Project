terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.72"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.29"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

provider "azuread" {
  tenant_id = var.tenant_id
}

# The Databricks provider authenticates via Azure Service Principal.
provider "databricks" {
  azure_client_id             = var.databricks_sp_client_id
  azure_client_secret         = var.databricks_sp_client_secret
  azure_tenant_id             = var.tenant_id
  azure_workspace_resource_id = module.databricks_workspace.workspace_resource_id
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "storage_account" {
  source              = "./modules/storage_account"
  name                = var.storage_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  account_tier        = var.storage_account_tier
  replication_type    = var.storage_account_replication
  tags                = var.tags
}

module "databricks_workspace" {
  source              = "./modules/databricks_workspace"
  name                = var.databricks_workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = var.databricks_sku
  tags                = var.tags
}

module "unity_catalog" {
  source                      = "./modules/unity_catalog"
  depends_on                  = [module.databricks_workspace, module.storage_account]
  metastore_name              = var.unity_metastore_name
  metastore_region            = var.location
  metastore_owner             = var.unity_metastore_owner
  workspace_id                = module.databricks_workspace.workspace_resource_id
  storage_account_id          = module.storage_account.id
  storage_account_name        = module.storage_account.name
  landing_container_url       = module.storage_account.container_urls["landing"]
  bronze_container_url        = module.storage_account.container_urls["bronze"]
  silver_container_url        = module.storage_account.container_urls["silver"]
  gold_container_url          = module.storage_account.container_urls["gold"]
  logs_container_url          = module.storage_account.container_urls["logs"]
  service_principal_client_id = var.databricks_sp_client_id
  service_principal_secret    = var.databricks_sp_client_secret
  tenant_id                   = var.tenant_id
}
