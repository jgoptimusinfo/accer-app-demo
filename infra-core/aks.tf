## --------------------------------------------------------
##  locals
## --------------------------------------------------------

## --------------------------------------------------------
##  AKS - Module Test
## --------------------------------------------------------
/*  
module "aks" {
  source = "../modules/aks"

  resource_group_name               = module.rg_main_aks.name
  location                          = var.location
  kubernetes_version                = var.aks_config.kubernetes_version
  orchestrator_version              = var.aks_config.orchestrator_version
  role_based_access_control_enabled = var.aks_config.role_based_access_control_enabled
  rbac_aad                          = var.aks_config.rbac_aad
  prefix                            = var.aks_config.prefix
  network_plugin                    = var.aks_config.network_plugin
  net_profile_dns_service_ip        = var.aks_config.net_profile_dns_service_ip
  net_profile_outbound_type         = var.aks_config.net_profile_outbound_type
  net_profile_pod_cidr              = var.aks_config.net_profile_pod_cidr
  net_profile_service_cidr          = var.aks_config.net_profile_service_cidr
  network_policy                    = var.aks_config.network_policy

  os_disk_size_gb                    = var.aks_config.os_disk_size_gb
  sku_tier                           = var.aks_config.sku_tier
  private_cluster_enabled            = var.aks_config.private_cluster_enabled
  enable_auto_scaling                = var.aks_config.enable_auto_scaling
  enable_host_encryption             = var.aks_config.enable_host_encryption
  log_analytics_workspace_enabled    = var.aks_config.log_analytics_workspace_enabled
  agents_min_count                   = var.aks_config.agents_min_count
  agents_max_count                   = var.aks_config.agents_max_count
  agents_count                       = var.aks_config.agents_count # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                    = var.aks_config.agents_max_pods
  agents_pool_name                   = var.aks_config.agents_pool_name
  agents_availability_zones          = var.aks_config.agents_availability_zones
  agents_type                        = var.aks_config.agents_type
  agents_size                        = var.aks_config.agents_size
  monitor_metrics                    = var.aks_config.monitor_metrics
  azure_policy_enabled               = var.aks_config.azure_policy_enabled
  microsoft_defender_enabled         = var.aks_config.microsoft_defender_enabled
  key_vault_secrets_provider_enabled = var.aks_config.key_vault_secrets_provider_enabled

  temporary_name_for_rotation = "pooltemp"
  workload_identity_enabled   = false
  oidc_issuer_enabled         = false

  log_analytics_workspace = {
    id                  = module.log_analytics_workspace.id
    name                = module.log_analytics_workspace.name
    location            = module.log_analytics_workspace.location
    resource_group_name = module.log_analytics_workspace.resource_group_name
  }

  log_analytics_solution = {
    id = module.log_analytics_workspace.solution_plan_name_id_map["ContainerInsights"]
  }

  attached_acr_id_map = {
    acr_dr = module.acr_main.container_registry_id
  }

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  node_pools = var.aks_map_nodes

  tags = var.tags

  depends_on = [module.vnet_main_network, module.rg_main_aks, module.log_analytics_workspace, module.acr_main]
}

## --------------------------------------------------------
##  AKS - Diagnostic Setting
## --------------------------------------------------------

module "aks_diagnostic_setting" {
  source = "../modules/diag-setting"

  name                              = "aks-diag-setting"
  target_log_analytics_workspace_id = module.log_analytics_workspace.id
  target_resource_id                = module.aks.aks_id
  log_analytics_destination_type    = "Dedicated"


  log_categories = [
    "kube-apiserver",
    "kube-audit",
    "kube-audit-admin",
    "kube-controller-manager",
    "kube-scheduler",
    "cluster-autoscaler",
    "cloud-controller-manager",
    "csi-azuredisk-controller",
    "csi-azurefile-controller",
    "csi-snapshot-controller"
  ]

  log_metrics = [
    "AllMetrics"
  ]
} */