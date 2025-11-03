output "id" {
  description = "Storage account resource ID"
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Storage account name"
  value       = azurerm_storage_account.this.name
}

output "container_urls" {
  description = "Map of container names to ABFSS URLs"
  value = { for name, container in azurerm_storage_container.data :
    name => format("abfss://%s@%s.dfs.core.windows.net", container.name, azurerm_storage_account.this.name)
  }
}
