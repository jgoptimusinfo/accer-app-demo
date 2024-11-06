
## --------------------------------------------------------
##  Azure SQL Server - Module 
## --------------------------------------------------------
 
module "sql_server" {
  source = "../modules/sql-server"

  location            = var.location
  resource_group_name = module.rg_main_shared.name
  sql_server_name     = var.sql_config.sql_server_name

  sql_admin_username = var.sql_config.sql_admin_username
  sql_password       = var.sql_config.sql_password
  server_version     = var.sql_config.server_version
  connection_policy  = var.sql_config.connection_policy

  sql_aad_administrator = {
    login_username              = var.sql_aad_administrator_config.login_username
    object_id                   = var.sql_aad_administrator_config.object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    azuread_authentication_only = var.sql_aad_administrator_config.azuread_authentication_only
  }

  tags = var.tags
}