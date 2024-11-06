## ----------------------------------------
## Azure SQL Server - Common
## ----------------------------------------

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

## ----------------------------------------
## Azure SQL Server - Variables
## ----------------------------------------

variable "sql_server_name" {
  type        = string
  description = "Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed"
}

variable "sql_admin_username" {
  type        = string
  description = "The administrator username of the SQL Server."
}

variable "sql_password" {
  type        = string
  description = "The administrator password of the SQL Server."
  sensitive   = true
}

variable "start_ip_address" {
  type        = string
  default     = "0.0.0.0"
  description = "Defines the start IP address used in your database firewall rule."
}

variable "end_ip_address" {
  type        = string
  default     = "0.0.0.0"
  description = "Defines the end IP address used in your database firewall rule."
}

variable "server_version" {
  type        = string
  default     = "12.0"
  description = "The version for the database server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
}

variable "connection_policy" {
  type        = string
  default     = "Default"
  description = "The connection policy of the server. Valid values are Default, Proxy, Redirect."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether public network access is allowed for this server. Possible values are `true` or `false`."
}

variable "outbound_network_restriction_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether the server should have its outbound network access restricted. Possible values are `true` or `false`."
}

variable "identity_ids" {
  default     = null
  description = "Specifies a list of user managed identity ids to be assigned. This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`"
}

variable "sql_aad_administrator" {
  type = object({
    login_username              = string
    object_id                   = string
    tenant_id                   = string
    azuread_authentication_only = optional(bool)
  })
  default     = null
  description = <<-EOF
  object({
    login = (Required) The login name of the principal to set as the server administrator
    object_id = (Required) The ID of the principal to set as the server administrator
    tenant_id = (Required) The Azure Tenant ID
    azuread_authentication_only = (Optional) Specifies whether only AD Users and administrators can be used to login (`true`) or also local database users (`false`).
  })
EOF
}