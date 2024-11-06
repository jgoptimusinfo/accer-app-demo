variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account"
}

variable "name" {
  type        = string
  description = "Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed"
}

variable "account_kind" {
  type        = string
  description = "Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`"
  default     = "StorageV2"
}

variable "account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium`"
  default     = "Standard"
}

variable "access_tier" {
  type        = string
  description = "Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`"
  default     = "Hot"
}

variable "account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`"
  default     = "ZRS"
}

variable "large_file_share_enabled" {
  type        = bool
  description = "Is Large File Share Enabled"
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether the public network access is enabled"
  default     = true
}

variable "network_rules" {
  type = object({
    bypass     = list(string),
    ip_rules   = list(string),
    subnet_ids = list(string)
  })
  description = "Network rules restricing access to the storage account"
  default     = null
}

variable "identity_ids" {
  default     = null
  description = "Specifies a list of user managed identity ids to be assigned. This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`"
}

variable "retention_policy_enabled" {
  type        = bool
  description = "Enable Blob Storage Account Retention Policy"
  default     = false
}

variable "delete_after_days_since_creation_greater_than" {
  type        = number
  description = "The number of days after creation that the blob should be deleted"
  default     = 365

}