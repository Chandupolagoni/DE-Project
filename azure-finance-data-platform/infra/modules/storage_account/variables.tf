variable "name" {
  type        = string
  description = "Name of the storage account"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the storage account"
}

variable "location" {
  type        = string
  description = "Azure region for the storage account"
}

variable "account_tier" {
  type        = string
  description = "Performance tier for the storage account"
}

variable "replication_type" {
  type        = string
  description = "Replication type for the storage account"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the storage account"
  default     = {}
}
