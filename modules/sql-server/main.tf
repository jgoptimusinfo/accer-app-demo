## --------------------------------------
##  LOCAL VARIABLES
## --------------------------------------

locals {
  tags = var.tags
}

## --------------------------------------
##  Azure SQL Server - Module
## --------------------------------------

resource "azurerm_mssql_server" "server" {
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_password
  location                     = var.location
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  version                      = var.server_version
  connection_policy            = var.connection_policy

  identity {
    type         = var.identity_ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids
  }
  primary_user_assigned_identity_id = var.identity_ids != null ? var.identity_ids[0] : null

  public_network_access_enabled        = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled

  dynamic "azuread_administrator" {
    for_each = var.sql_aad_administrator != null ? [1] : []
    content {
      login_username              = var.sql_aad_administrator.login_username
      object_id                   = var.sql_aad_administrator.object_id
      tenant_id                   = var.sql_aad_administrator.tenant_id
      azuread_authentication_only = var.sql_aad_administrator.azuread_authentication_only
    }
  }

  tags = local.tags
}

resource "azurerm_mssql_firewall_rule" "fw" {
  end_ip_address   = var.end_ip_address
  name             = "${var.sql_server_name}-fwrules"
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = var.start_ip_address
}