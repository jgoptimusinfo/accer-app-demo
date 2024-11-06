
## --------------------------------------------------------
##  Azure ServiceBus - Module 
## --------------------------------------------------------

module "servicebus" {
  source = "../modules/servicebus"

  location            = var.location
  resource_group_name = module.rg_main_shared.name
  name                = var.servicebus_config.name
  sku                 = var.servicebus_config.sku
  local_auth_enabled  = var.servicebus_config.local_auth_enabled
  enable_telemetry    = false

  queues = var.servicebus_queues

  tags = var.tags

}
