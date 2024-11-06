## --------------------------------------
##  MONITOR DIAGNOSTIC SETTING
## --------------------------------------

resource "azurerm_monitor_diagnostic_setting" "diag" {

  name                       = var.name
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.target_log_analytics_workspace_id
  storage_account_id         = var.target_storage_account_id

  log_analytics_destination_type = var.log_analytics_destination_type

  dynamic "enabled_log" {
    for_each = var.log_categories

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.log_metrics

    content {
      category = metric.value
    }
  }

  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}
