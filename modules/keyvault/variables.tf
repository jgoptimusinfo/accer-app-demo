## --------------------------------------
##  KEY VAULT - Variables
## --------------------------------------

variable "location" {
  type        = string
  description = "Region to create environment"
}

variable "name" {
  type        = string
  description = "Resource group name"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}

variable "sku_name" {
  type        = string
  description = "SKU name"
  default     = "standard"
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Soft delete retention days"
  default     = 7
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Is Purge Protection enabled for this Key Vault?"
  default     = false
}

variable "enabled_for_deployment" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  default     = true
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  default     = false
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether public network access is allowed for this Key Vault. Defaults to true"
  default     = true
}

variable "network_acls" {
  type = object({
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
    bybass                     = string
  })
  description = "(Optional) Network ACL config"
  default     = null
}

variable "kv_admins_ad_group" {
  type        = string
  description = "KeyVault admins group"
  default     = null
}

variable "kv_readers_ad_group" {
  type        = string
  description = "KeyVault readers group"
  default     = null
}
