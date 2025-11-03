resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  account_kind             = "StorageV2"
  is_hns_enabled           = true
  allow_nested_items_to_be_public = false
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

locals {
  containers = ["landing", "bronze", "silver", "gold", "logs"]
}

resource "azurerm_storage_container" "data" {
  for_each              = toset(locals.containers)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}
