output "metastore_id" {
  description = "Unity Catalog metastore ID"
  value       = databricks_metastore.this.id
}
