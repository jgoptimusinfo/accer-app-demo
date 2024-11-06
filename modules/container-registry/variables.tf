## ----------------------------------------
## ACR - Variables
## ----------------------------------------

variable "location" {
  type        = string
  description = "ACR Location"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "ACR Resource Group Name"
}

variable "container_registry_config" {
  type = object({
    name                          = string
    admin_enabled                 = optional(bool)
    sku                           = optional(string)
    public_network_access_enabled = optional(bool)
    quarantine_policy_enabled     = optional(bool)
    zone_redundancy_enabled       = optional(bool)
  })
  description = "Manages an Azure Container Registry"
}

variable "data_endpoint_enabled" {
  default     = false
  description = "Boolean value to enable or disable Data endpoint in Azure Container Registry"
}

variable "georeplications" {
  type = list(object({
    location                = string
    zone_redundancy_enabled = optional(bool)
  }))
  default     = []
  description = "A list of Azure locations where the container registry should be geo-replicated"
}

variable "network_rule_set" { # change this to match actual objects
  description = "Manage network rules for Azure Container Registries"
  type = object({
    default_action = optional(string)
    ip_rule = optional(list(object({
      ip_range = string
    })))
  })
  default = null
}

variable "retention_policy" {
  type = object({
    days    = optional(number)
    enabled = optional(bool)
  })
  default     = null
  description = "Set a retention policy for untagged manifests"
}

variable "enable_content_trust" {
  default     = false
  description = "Boolean value to enable or disable Content trust in Azure Container Registry"
}

variable "identity_ids" {
  default     = null
  description = "Specifies a list of user managed identity ids to be assigned. This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`"
}

variable "scope_map" {
  type = map(object({
    actions = list(string)
  }))
  default     = null
  description = "Manages an Azure Container Registry scope map. Scope Maps are a preview feature only available in Premium SKU Container registries."
}

variable "container_registry_webhooks" {
  type = map(object({
    service_uri    = string
    actions        = list(string)
    status         = optional(string)
    scope          = string
    custom_headers = map(string)
  }))
  default     = null
  description = "Manages an Azure Container Registry Webhook"
}