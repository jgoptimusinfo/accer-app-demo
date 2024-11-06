## --------------------------------------
##  LOCAL VARIABLES
## --------------------------------------

locals {
  tags = var.tags
}

## --------------------------------------
##  Azure Contanier Registry - ACR
## --------------------------------------

resource "azurerm_container_registry" "main" {
  name                          = var.container_registry_config.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  admin_enabled                 = var.container_registry_config.admin_enabled
  sku                           = var.container_registry_config.sku
  public_network_access_enabled = var.container_registry_config.public_network_access_enabled
  quarantine_policy_enabled     = var.container_registry_config.quarantine_policy_enabled
  zone_redundancy_enabled       = var.container_registry_config.zone_redundancy_enabled
  data_endpoint_enabled         = var.data_endpoint_enabled

  tags = local.tags


  dynamic "georeplications" {
    for_each = var.georeplications
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
      tags                    = merge({ "Name" = format("%s", "georep-${georeplications.value.location}") }, local.tags, )
    }
  }

  dynamic "network_rule_set" {
    for_each = var.network_rule_set != null ? [var.network_rule_set] : []
    content {
      default_action = lookup(network_rule_set.value, "default_action", "Allow")

      dynamic "ip_rule" {
        for_each = network_rule_set.value.ip_rule
        content {
          action   = "Allow"
          ip_range = ip_rule.value.ip_range
        }
      }
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? [var.retention_policy] : []
    content {
      days    = lookup(retention_policy.value, "days", 7)
      enabled = lookup(retention_policy.value, "enabled", true)
    }
  }

  dynamic "trust_policy" {
    for_each = var.enable_content_trust ? [1] : []
    content {
      enabled = var.enable_content_trust
    }
  }

  identity {
    type         = var.identity_ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids
  }
}

#------------------------------------------------------------
# Container Registry Resource Scope map - Default is "false"
#------------------------------------------------------------

resource "azurerm_container_registry_scope_map" "main" {
  for_each                = var.scope_map != null ? { for k, v in var.scope_map : k => v if v != null } : {}
  name                    = format("%s", each.key)
  resource_group_name     = var.resource_group_name
  container_registry_name = azurerm_container_registry.main.name
  actions                 = each.value["actions"]
}

#------------------------------------------------------------
# Container Registry Token  - Default is "false"
#------------------------------------------------------------

resource "azurerm_container_registry_token" "main" {
  for_each                = var.scope_map != null ? { for k, v in var.scope_map : k => v if v != null } : {}
  name                    = format("%s", "${each.key}-token")
  resource_group_name     = var.resource_group_name
  container_registry_name = azurerm_container_registry.main.name
  scope_map_id            = element([for k in azurerm_container_registry_scope_map.main : k.id], 0)
  enabled                 = true
}

#------------------------------------------------------------
# Container Registry webhook - Default is "true"
#------------------------------------------------------------

resource "azurerm_container_registry_webhook" "main" {
  for_each            = var.container_registry_webhooks != null ? { for k, v in var.container_registry_webhooks : k => v if v != null } : {}
  name                = format("%s", each.key)
  resource_group_name = var.resource_group_name
  location            = var.location
  registry_name       = azurerm_container_registry.main.name
  service_uri         = each.value["service_uri"]
  actions             = each.value["actions"]
  status              = each.value["status"]
  scope               = each.value["scope"]
  custom_headers      = each.value["custom_headers"]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}