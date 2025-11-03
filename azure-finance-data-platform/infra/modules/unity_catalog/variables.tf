variable "metastore_name" {
  type        = string
  description = "Unity Catalog metastore name"
}

variable "metastore_region" {
  type        = string
  description = "Region for the metastore"
}

variable "metastore_owner" {
  type        = string
  description = "Owner of the metastore"
}

variable "workspace_id" {
  type        = string
  description = "Workspace resource ID"
}

variable "storage_account_id" {
  type        = string
  description = "Storage account resource ID"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"
}

variable "landing_container_url" {
  type        = string
  description = "ABFSS URL for the landing container"
}

variable "bronze_container_url" {
  type        = string
  description = "ABFSS URL for the bronze container"
}

variable "silver_container_url" {
  type        = string
  description = "ABFSS URL for the silver container"
}

variable "gold_container_url" {
  type        = string
  description = "ABFSS URL for the gold container"
}

variable "logs_container_url" {
  type        = string
  description = "ABFSS URL for the logs container"
}

variable "service_principal_client_id" {
  type        = string
  description = "Service principal client ID"
}

variable "service_principal_secret" {
  type        = string
  description = "Service principal secret"
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID"
}
