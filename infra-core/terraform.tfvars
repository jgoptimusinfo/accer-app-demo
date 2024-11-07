## ------------------------------------
##  COMMON VARIABLES
## ------------------------------------

location = "eastus2"

tags = {
  "Environment" = "prod"
  "Owner"       = "Javier.Gaibisso"
  "Application" = "accern-aks"
  "ID"          = "00000001"
}

shared_resource_group_name = "accern-shared-prd-eus2-rg"

## ------------------------------------
##  Networking Configuration
## ------------------------------------

virtual_network_resource_group_name = "accern-nwsvcs-prd-eus2-rg"
virtual_network_address_space       = "10.20.0.0/16"
virtual_network_prefix_name         = "accern-nwsvcs-prd-eus2"
enable_vpn_gateway                  = false

subnets = {
  appgw_snet = {
    name                                          = "appgw"
    address_prefixes                              = ["10.20.0.0/24"]
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
  },
  compute_snet = {
    name                                          = "compute"
    address_prefixes                              = ["10.20.1.0/24"]
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
  },
  aks_snet = {
    name                                          = "aks"
    address_prefixes                              = ["10.20.8.0/21"]
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
  }
}

routes = {}

## ------------------------------------
##  KeyVault Configuration
## ------------------------------------

keyvault_config = {
  name                          = "accern-cf-prd-eus2-kv"
  sku_name                      = "standard"
  soft_delete_retention_days    = 7 # 90
  purge_protection_enabled      = false
  public_network_access_enabled = true
}

## ------------------------------------
##  ACR Configuration
## ------------------------------------

container_registry_config = {
  name                          = "acraccernprdasdf"
  admin_enabled                 = true
  sku                           = "Standard" # "Premium"
  public_network_access_enabled = true
  quarantine_policy_enabled     = false
  zone_redundancy_enabled       = false
}

data_endpoint_enabled = false # true Only in "Premium" SKU

## ------------------------------------
##  Log Analytics Workspace Configuration
## ------------------------------------

law_config = {
  name           = "accern-shared-prd-eus2-log"
  sku            = "PerGB2018"
  retention_days = 30
  daily_quota    = -1
}

## ------------------------------------
##  Storage Account 001 Configuration
## ------------------------------------

storage_account_config = {
  name                          = "accernprddsfahygas"
  account_replication_type      = "GRS"
  large_file_share_enabled      = false
  public_network_access_enabled = true
  account_tier                  = "Standard"
  account_kind                  = "StorageV2"
  access_tier                   = "Hot"
}

## ------------------------------------
##  Application Gateway Configuration
## ------------------------------------

appag_umid_name       = "appag-prd-umi"

## ------------------------------------
##  AKS Configuration
## ------------------------------------

aks_resource_group_name = "accern-aks-prd-eus2-rg"

aks_config = {
  kubernetes_version                = "1.29"
  orchestrator_version              = "1.29"
  role_based_access_control_enabled = true
  rbac_aad                          = false
  prefix                            = "accern-prd-eau2-aks"
  network_plugin                    = "kubenet"
  net_profile_dns_service_ip        = "10.0.0.10"
  net_profile_outbound_type         = "managedNATGateway" # "loadBalancer" or "managedNATGateway"
  net_profile_pod_cidr              = "10.244.0.0/16"
  net_profile_service_cidr          = "10.0.0.0/16"
  network_policy                    = "calico"

  os_disk_size_gb                    = 128
  sku_tier                           = "Standard"
  private_cluster_enabled            = false
  enable_auto_scaling                = true
  enable_host_encryption             = false
  log_analytics_workspace_enabled    = true
  agents_min_count                   = 1
  agents_max_count                   = 5
  agents_count                       = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                    = 100
  agents_pool_name                   = "sysmsiprd"
  agents_availability_zones          = []
  agents_type                        = "VirtualMachineScaleSets"
  agents_size                        = "Standard_D2s_v3"
  monitor_metrics                    = {}
  azure_policy_enabled               = true
  microsoft_defender_enabled         = false
  key_vault_secrets_provider_enabled = true
}


aks_map_nodes = {
  node_1 = {
    name                      = "node132g"
    vm_size                   = "Standard_D2s_v3"
    node_count                = null
    agents_availability_zones = []
    enable_auto_scaling       = true
    max_count                 = 5
    min_count                 = 1
    max_pods                  = 110
    mode                      = "User"
    os_disk_size_gb           = 128
    os_disk_type              = "Managed" # Managed or Ephemeral, check VM SKU availability
    os_type                   = "Linux"
    os_sku                    = "Ubuntu"
    orchestrator_version      = "1.29"
    node_labels = {
          "nodepool" : "prdprimary32g"
        }

    create_before_destroy = true
  },
  node_2 = {
    name                      = "node232g"
    vm_size                   = "Standard_D2s_v3"
    node_count                = null
    agents_availability_zones = []
    enable_auto_scaling       = true
    max_count                 = 5
    min_count                 = 1
    max_pods                  = 110
    mode                      = "User"
    os_disk_size_gb           = 128
    os_disk_type              = "Managed" # Managed or Ephemeral, check VM SKU availability
    os_type                   = "Linux"
    os_sku                    = "Ubuntu"
    orchestrator_version      = "1.29"
    node_labels = {
          "nodepool" : "prdsecondary32g"
        }

    create_before_destroy = true
  }
}