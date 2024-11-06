
## --------------------------------------------------------
##  Log analitycs Workspace - Main
## --------------------------------------------------------
/* 
module "log_analytics_workspace" {
  source = "../modules/log-workspace"

  location            = var.location
  resource_group_name = module.rg_main_shared.name
  name                = var.law_config.name
  sku                 = var.law_config.sku
  retention_days      = var.law_config.retention_days
  daily_quota_gb      = var.law_config.daily_quota

  solution_plan_map = {
    "ContainerInsights" = {
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    }
    "AzureActivity" = {
      product   = "OMSGallery/AzureActivity"
      publisher = "Microsoft"
    }
  }
  tags = var.tags
} 
 */