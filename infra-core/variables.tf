## ------------------------------------
##  COMMON VARIABLES
## ------------------------------------

variable "location" {
  type        = string
  default     = "eastus"
  description = "all resource location"
}

variable "tags" {
  type        = map(string)
  description = "tags value for resources"
}

variable "shared_resource_group_name" {
  type        = string
  description = "Shared Resource Group Name"  
}

## ------------------------------------
##  Networking Variables
## ------------------------------------

variable "virtual_network_resource_group_name" {
  description = "The Virtual Network Resource Group Name"
  type        = string
}

variable "virtual_network_prefix_name" {
  description = "The Virtual Network Prefix Name"
  type        = string
}

variable "virtual_network_address_space" {
  description = "The Virtual Network Address Space"
  type        = string
}

variable "subnets" {
  description = "value for subnets"
  type = map(object({
    name                                          = string
    address_prefixes                              = list(string)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, false)
    service_endpoints                             = optional(set(string), [])
    service_endpoint_policy_ids                   = optional(list(string), [])
    service_delegation_name                       = optional(string, null)
    service_delegation_actions                    = optional(list(string), [])
  }))
  default = {}
}

variable "routes" {
  description = "Map of spoke routes"
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string, null)
  }))

  default = {}
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway ?"
  type        = bool
  default     = false
}

## ------------------------------------
##  Keyvault Variables
## ------------------------------------

variable "keyvault_config" {
  description = "Configuration for Keyvault"
  type = object({
    name                          = string
    sku_name                      = string
    soft_delete_retention_days    = number
    purge_protection_enabled      = bool
    public_network_access_enabled = bool
  })
}

variable "appag_umid_name" {
  description = "The name of the User Managed Identity for App Gateway"
  type        = string
}

## ------------------------------------
##  ACR Variables
## ------------------------------------

variable "container_registry_config" {
  description = "Configuration for Azure Container Registry"
  type = object({
    name                          = string
    admin_enabled                 = bool
    sku                           = string
    public_network_access_enabled = bool
    quarantine_policy_enabled     = bool
    zone_redundancy_enabled       = bool
  })
}

variable "data_endpoint_enabled" {
  description = "Enable Data Endpoint ?"
  type        = bool
  default     = false
}

## ------------------------------------
##  Log Analytics Workspace Variables
## ------------------------------------

variable "law_config" {
  description = "Configuration for Log Analytics Workspace"
  type = object({
    name           = string
    sku            = string
    retention_days = number
    daily_quota    = number
  })
}

## ------------------------------------
##  Storage Account Variables
## ------------------------------------

variable "storage_account_config" {
  description = "Configuration for Storage Account"
  type = object({
    name                          = string
    account_replication_type      = string
    large_file_share_enabled      = bool
    public_network_access_enabled = bool
    account_tier                  = string
    account_kind                  = string
    access_tier                   = string
  })
}

## ------------------------------------
##  AKS Variables
## ------------------------------------

variable "aks_resource_group_name" {
  description = "The name of the AKS Resource Group."
  type        = string
}

variable "aks_config" {
  description = "Configuration for AKS"
  type = object({
    kubernetes_version                 = string
    orchestrator_version               = string
    role_based_access_control_enabled  = bool
    rbac_aad                           = bool
    prefix                             = string
    network_plugin                     = string
    net_profile_dns_service_ip         = string
    net_profile_outbound_type          = string
    net_profile_pod_cidr               = string
    net_profile_service_cidr           = string
    network_policy                     = string
    os_disk_size_gb                    = number
    sku_tier                           = string
    private_cluster_enabled            = bool
    enable_auto_scaling                = bool
    enable_host_encryption             = bool
    log_analytics_workspace_enabled    = bool
    agents_min_count                   = number
    agents_max_count                   = number
    agents_count                       = number
    agents_max_pods                    = number
    agents_pool_name                   = string
    agents_availability_zones          = list(string)
    agents_type                        = string
    agents_size                        = string
    monitor_metrics                    = map(string)
    azure_policy_enabled               = bool
    microsoft_defender_enabled         = bool
    key_vault_secrets_provider_enabled = bool
  })
}

variable "aks_map_nodes" {
  description = "A map of nodes which should be created within the AKS Cluster."
  type = map(object({
    name                      = string
    vm_size                   = string
    node_count                = number
    agents_availability_zones = list(string)
    enable_auto_scaling       = bool
    max_count                 = number
    min_count                 = number
    max_pods                  = number
    mode                      = string
    os_disk_size_gb           = number
    os_disk_type              = string
    os_type                   = string
    os_sku                    = string
    orchestrator_version      = string
    create_before_destroy     = bool
  }))
}


/* 
## ------------------------------------
##  Network Security Group Configuration
## ------------------------------------

variable "backend_network_security_group_name" {
  description = "The name of the backend Network Security Group."
  type        = string
}

variable "backend_security_rules" {
  description = "A list of security rules which should be created within the Network Security Group."
  type        = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {}
  
}

variable "frontend_network_security_group_name" {
  description = "The name of the frontend Network Security Group."
  type        = string
}

variable "frontend_security_rules" {
  description = "A list of security rules which should be created within the Network Security Group."
  type        = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {}
}

variable "citrix_network_security_group_name" {
  description = "The name of the frontend Network Security Group."
  type        = string
}

variable "citrix_security_rules" {
  description = "A list of security rules which should be created within the Network Security Group."
  type        = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {}
}

variable "ads_network_security_group_name" {
  description = "The name of the frontend Network Security Group."
  type        = string
}

variable "ads_security_rules" {
  description = "A list of security rules which should be created within the Network Security Group."
  type        = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {}
}
 */