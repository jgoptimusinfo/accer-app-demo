## --------------------------------------------------------
##  Application Gateway - User Assigned Identity 
## --------------------------------------------------------
 
resource "azurerm_user_assigned_identity" "appag_umid" {
  location            = var.location
  name                = var.appag_umid_name
  resource_group_name = module.rg_main_network.name
}

resource "azurerm_key_vault_access_policy" "appag_key_vault_access_policy" {
  key_vault_id = module.keyvault_main.id
  object_id    = azurerm_user_assigned_identity.appag_umid.principal_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  secret_permissions = [
    "Get",
  ]
  depends_on = [ azurerm_key_vault_certificate.ssl_cert ]
}

## --------------------------------------------------------
##  Application Gateway - Module 
## --------------------------------------------------------

module "application_gateway" {
  source = "../modules/app-gateway"

  resource_group_name = module.rg_main_network.name
  location            = var.location

  name                = var.app_gateway_config.name
  public_ip_name      = var.app_gateway_config.public_ip_name
  subnet_name_backend = var.app_gateway_config.subnet_name_backend
  vnet_name           = module.vnet_main_network.vnet_name

  enable_telemetry = false

  # Zone redundancy for the application gateway ["1", "2", "3"] 
  zones = ["1"]

  tags = var.tags

  identity_ids = [
    azurerm_user_assigned_identity.appag_umid.id
  ]

  sku = {
    name     = var.app_gateway_sku.name
    tier     = var.app_gateway_sku.tier
    capacity = var.app_gateway_sku.capacity
  }

  autoscale_configuration = {
    min_capacity = var.app_gateway_autoscale_configuration.min_capacity
    max_capacity = var.app_gateway_autoscale_configuration.max_capacity
  }

  waf_configuration = var.waf_configuration

  ssl_certificates = [
    {
      name                = var.ssl_certificates_name
      key_vault_secret_id = azurerm_key_vault_certificate.ssl_cert.secret_id
    }
  ]

  # frontend_ports configuration for the application gateway
  frontend_ports = var.frontend_ports

  # Backend address pool configuration for the application gateway
  backend_address_pools = var.backend_address_pools

  # Backend http settings configuration for the application gateway
  backend_http_settings = var.backend_http_settings

  # Http Listerners configuration for the application gateway
  http_listeners = var.http_listeners

  # Redirect configuration to apply to the application gateway
  redirect_configuration = var.redirect_configuration

  # Routing rules configuration for the backend pool
  request_routing_rules = var.request_routing_rules

  diagnostic_settings = {
    example_setting = {
      name                           = "appgw-diagnostic-setting"
      workspace_resource_id          = module.log_analytics_workspace.id
      log_analytics_destination_type = "Dedicated" # Or "AzureDiagnostics"
      log_groups                     = ["allLogs"]
      metric_categories              = ["AllMetrics"]
    }
  }

  depends_on = [module.vnet_main_network, module.rg_main_network, module.log_analytics_workspace]
}
