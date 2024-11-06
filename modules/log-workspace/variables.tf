## ----------------------------------------
## Log Analytics Workspace Variables
## ----------------------------------------

variable "name" {
  type        = string
  description = "Log Analytics Workspace Name"
}

variable "location" {
  type        = string
  description = "Log Analytics Workspace Location"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "Log Analytics Workspace Resource Group Name"
}

variable "sku" {
  type        = string
  description = "Log Analytics Workspace SKU"
  default     = "PerGB2018"
}

variable "retention_days" {
  type        = number
  description = "The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730"
  default     = 30
}

variable "daily_quota_gb" {
  type        = number
  description = "The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted."
  default     = "-1"
}

variable "law_owners_ad_group" {
  type        = string
  description = "KeyVault admins group"
  default     = null
}

variable "solution_plan_map" {
  description = "(Optional) Specifies the map structure containing the list of solutions to be enabled."
  type        = map(any)
  default     = {}
}