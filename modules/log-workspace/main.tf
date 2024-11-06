## --------------------------------------
##  LOCAL VARIABLES
## --------------------------------------

locals {
  tags = var.tags
}

## --------------------------------------
##  LOG ANALYTICS WORKSPACE
## --------------------------------------

resource "azurerm_log_analytics_workspace" "law" {

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_days
  daily_quota_gb      = var.daily_quota_gb

  cmk_for_query_forced                    = false
  immediate_data_purge_on_30_days_enabled = false
  internet_ingestion_enabled              = true
  internet_query_enabled                  = true

  tags = local.tags
}

## -------------------------------------------------------------------------------------------
##  Log Analytics Workspace RBAC Role Assignment for "g-sec-log-analytics-workspace-admin"
## -------------------------------------------------------------------------------------------

data "azuread_group" "g_sec_log_cntrl_admins" {
  count = var.law_owners_ad_group == null ? 0 : 1

  display_name = var.law_owners_ad_group
}

resource "azurerm_role_assignment" "law_role_asgnmnt" {
  count = var.law_owners_ad_group == null ? 0 : 1

  scope                = azurerm_log_analytics_workspace.law.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_group.g_sec_log_cntrl_admins[0].object_id
}

## -------------------------------------------------------------------------------------------
##  Log Analytics Workspace solutions
## -------------------------------------------------------------------------------------------

resource "azurerm_log_analytics_solution" "law_solution" {
  for_each = var.solution_plan_map

  solution_name         = each.key
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name

  plan {
    product   = each.value.product
    publisher = each.value.publisher
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}