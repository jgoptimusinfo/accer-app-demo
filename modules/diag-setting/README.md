# Azure Monitor Diagnostic Setting Module

This Terraform module is designed to create and manage Azure Monitor Diagnostic Settings. It allows you to configure diagnostic settings to send platform logs and metrics to different destinations such as Log Analytics workspaces, Event Hubs, and Azure Storage accounts.

## Features

- **Log Analytics Workspace Integration**: Send logs and metrics to a specified Log Analytics workspace.
- **Storage Account Integration**: Archive logs and metrics to a specified Azure Storage account.
- **Dynamic Log and Metric Categories**: Flexibly specify which log and metric categories to enable for monitoring.

## Usage

Below is an example of how to use this module to configure diagnostic settings for an Azure resource.

```hcl
module "monitor_diagnostic_setting" {
  source  = "../modules/diag-setting" # Replace with final path on this module

  name                          = "example-diag-setting"
  target_resource_id            = azurerm_resource_group.example.id
  log_analytics_workspace_id    = azurerm_log_analytics_workspace.example.id
  storage_account_id            = azurerm_storage_account.example.id
  log_analytics_destination_type = "Dedicated"

  log_categories = [
    "AuditLogs",
    "SignInLogs"
  ]

  log_metrics = [
    "AllMetrics"
  ]
}