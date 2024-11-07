## --------------------------------------------------------
##  locals
## --------------------------------------------------------

## --------------------------------------------------------
##  Azure Contanier Registry - ACR
## --------------------------------------------------------
/*   
module "acr_main" {
  source = "../modules/container-registry"

  location                  = var.location
  resource_group_name       = module.rg_main_shared.name
  data_endpoint_enabled     = var.data_endpoint_enabled
  container_registry_config = var.container_registry_config

  tags = var.tags
}

## --------------------------------------------------------
##  ACR - Diagnostic Setting
## --------------------------------------------------------

module "acr_diagnostic_setting" {
  source = "../modules/diag-setting"

  name                              = "acr-diag-setting"
  target_log_analytics_workspace_id = module.log_analytics_workspace.id
  target_resource_id                = module.acr_main.container_registry_id
  log_analytics_destination_type    = "Dedicated"

  log_categories = [
    "ContainerRegistryRepositoryEvents",
    "ContainerRegistryLoginEvents"
  ]

  log_metrics = [
    "AllMetrics"
  ]
} */