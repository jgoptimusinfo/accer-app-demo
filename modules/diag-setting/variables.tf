
variable "name" {
  type        = string
  description = " Specifies the name of the Diagnostic Setting."
}

variable "target_resource_id" {
  type        = string
  description = "The ID of Azure Resource on which to configure Diagnostic Settings"
}

variable "target_log_analytics_workspace_id" {
  type        = string
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent"
}

variable "target_storage_account_id" {
  type        = string
  description = "The ID of the Storage Account where logs should be sent."
  default     = null
}

variable "log_analytics_destination_type" {
  type        = string
  description = "Possible values are AzureDiagnostics and Dedicated. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
  default     = "Dedicated"
}

variable "log_categories" {
  type        = list(string)
  description = "Log Categories for this Resource"
}

variable "log_metrics" {
  type        = list(string)
  description = "Metrics required for this Resource"
}