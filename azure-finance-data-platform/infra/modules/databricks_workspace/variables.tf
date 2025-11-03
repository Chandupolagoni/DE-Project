variable "name" {
  type        = string
  description = "Databricks workspace name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "sku" {
  type        = string
  description = "Databricks workspace SKU"
  default     = "premium"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the workspace"
  default     = {}
}
