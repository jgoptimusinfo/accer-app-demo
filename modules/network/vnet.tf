#--------------------------
# Azure Virtual Network
# -------------------------

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [var.ddos_protection_plan] : []
    content {
      enable = var.ddos_protection_plan.enable
      id     = var.ddos_protection_plan.id
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_diagnostic_setting" "settings" {
  count = var.log_analytics_workspace_id == null ? 0 : 1

  name                       = "DiagnosticsSettings"
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
  }
}
