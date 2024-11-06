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
##  SQL Variable Variables
## ------------------------------------

variable "sql_config" {
  description = "Configuration for SQL Server"
  type = object({
    sql_server_name    = string
    sql_admin_username = string
    sql_password       = string
    server_version     = string
    connection_policy  = string
  })
}

variable "sql_aad_administrator_config" {
  description = "Configuration for SQL Server AAD Administrator"
  type = object({
    login_username              = string
    object_id                   = string
    azuread_authentication_only = bool
  })
}

## ------------------------------------
##  Application Gateway Variables
## ------------------------------------

variable "appag_umid_name" {
  description = "The name of the User Assigned Managed Identity for Application Gateway."
  type        = string
}

variable "app_gateway_config" {
  description = "Configuration for Application Gateway"
  type = object({
    name                = string
    public_ip_name      = string
    subnet_name_backend = string
  })
}

variable "app_gateway_sku" {
  description = "Configuration for Application Gateway SKU"
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}

variable "app_gateway_autoscale_configuration" {
  description = "Configuration for Application Gateway Autoscale"
  type = object({
    min_capacity = number
    max_capacity = number
  })
}

variable "waf_configuration" {
  description = "Configuration for Web Application Firewall"
  type = list(object({
    enabled          = bool
    firewall_mode    = string
    rule_set_type    = string
    rule_set_version = string
  }))
}

variable "ssl_certificates_name" {
  description = "The name of the SSL Certificate."
  type        = string
}

variable "frontend_ports" {
  description = "The frontend ports for the Application Gateway."
  type = map(object({
    name = string
    port = number
  }))
  default = {}
}

variable "backend_address_pools" {
  description = "The backend address pools for the Application Gateway."
  type = map(object({
    name         = string
    ip_addresses = list(string)
  }))
  default = {}
}

variable "backend_http_settings" {
  description = "The backend http settings for the Application Gateway."
  type = map(object({
    name                  = string
    cookie_based_affinity = string
    path                  = string
    enable_https          = bool
    port                  = number
    request_timeout       = number
    connection_draining = object({
      enable_connection_draining = bool
      drain_timeout_sec          = number
    })
  }))
  default = {}
}

variable "http_listeners" {
  description = "The http listeners for the Application Gateway."
  type = map(object({
    name                 = string
    frontend_port_name   = string
    ssl_certificate_name = optional(string, null)
    host_name            = optional(string, null)
  }))
  default = {}
}

variable "redirect_configuration" {
  description = "The redirect configuration for the Application Gateway."
  type = map(object({
    name                 = string
    redirect_type        = string
    target_listener_name = string
    include_path         = bool
    include_query_string = bool
  }))
  default = {}
}

variable "request_routing_rules" {
  description = "The request routing rules for the Application Gateway."
  type = map(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = optional(string, null)
    backend_http_settings_name  = optional(string, null)
    redirect_configuration_name = optional(string, null)
    priority                    = number
  }))
  default = {}
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

## ------------------------------------
##  Azure ServiceBus Variables
## ------------------------------------

variable "servicebus_config" {
  description = "Configuration for Azure ServiceBus"
  type = object({
    name               = string
    sku                = string
    local_auth_enabled = bool
  })
}

variable "servicebus_queues" {
  description = "A list of queues which should be created within the ServiceBus."
  type = map(object({
    name                                    = string
    max_delivery_count                      = number
    enable_batched_operations               = bool
    requires_duplicate_detection            = bool
    requires_session                        = bool
    dead_lettering_on_message_expiration    = bool
    enable_partitioning                     = bool
    enable_express                          = bool
    max_message_size_in_kilobytes           = optional(number, null)
    default_message_ttl                     = string
    forward_to                              = optional(string, null)
    forward_dead_lettered_messages_to       = optional(string, null)
    auto_delete_on_idle                     = optional(string, null)
    max_size_in_megabytes                   = number
    lock_duration                           = string
    duplicate_detection_history_time_window = string
    status                                  = string
  }))
  default = {}

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