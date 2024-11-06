## ------------------------------------
##  COMMON VARIABLES
## ------------------------------------

location = "eastus2"

tags = {
  "Environment" = "sandbox"
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
##  Azure SQL Configuration
## ------------------------------------

sql_config = {
  sql_server_name    = "accern-sql-prd-eus2-sql"
  sql_admin_username = "sqladmin"
  sql_password       = "hsikjdhfgiu34512@35"
  server_version     = "12.0"
  connection_policy  = "Default"
}

sql_aad_administrator_config = {
  login_username              = "aadsqladmin"
  object_id                   = "95b881f6-5390-4914-ae1f-78e2c1d3c992" # "aadsqladmin"
  azuread_authentication_only = false
}

## ------------------------------------
##  Application Gateway Configuration
## ------------------------------------

appag_umid_name       = "appag-prd-umi"
ssl_certificates_name = "generated-cert"

app_gateway_config = {
  name                = "acr-nwsvcs-prd-eus2-agw"
  public_ip_name      = "acr-nwsvcs-prd-eus2-pip"
  subnet_name_backend = "acr-nwsvcs-prd-eus2-snet-appgw"
}

app_gateway_sku = {
  name     = "WAF_v2"
  tier     = "WAF_v2"
  capacity = 0 # Set the initial capacity to 0 for autoscaling
}

app_gateway_autoscale_configuration = {
  min_capacity = 1
  max_capacity = 2
}

waf_configuration = [
  {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.1"
  }
]

frontend_ports = {
  frontend-port-80 = {
    name = "frontend-port-80"
    port = 80
  },
  frontend-port-443 = {
    name = "frontend-port-443"
    port = 443
  }
  # Add more ports as needed
}

backend_address_pools = {
  Pool1 = {
    name         = "acr-nwsvcs-prd-esus2-agw-rule-containers"
    ip_addresses = ["100.224.0.10"]
  },
  Pool2 = {
    name         = "acr-nwsvcs-prd-secondary-rule-containers"
    ip_addresses = ["100.224.0.14"]
  }
  # Add more backends as needed
}

backend_http_settings = {
  myHTTPSetting = {
    name                  = "myHTTPSetting"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    enable_https          = false
    port                  = 80
    request_timeout       = 600
    connection_draining = {
      enable_connection_draining = false
      drain_timeout_sec          = 300

    }
  }
  # Add more backend http settings as needed
}

http_listeners = {
  cfprdlistenerhttps = {
    name                 = "cfprdlistenerhttps"
    frontend_port_name   = "frontend-port-443"
    ssl_certificate_name = "generated-cert"
    host_name            = null
  },
  cfprodlistener = {
    name               = "cfprodlistener"
    frontend_port_name = "frontend-port-80"
    host_name          = null
  }
  # Add more http listeners as needed
}

redirect_configuration = {
  redirect = {
    name                 = "redirect"
    redirect_type        = "Temporary" # Or "Permanent"
    target_listener_name = "cfprdlistenerhttps"
    include_path         = true
    include_query_string = true

  }
}

request_routing_rules = {
  console-prod-rule-https = {
    name                       = "console-prd-rule-https"
    rule_type                  = "Basic"
    http_listener_name         = "cfprdlistenerhttps"
    backend_address_pool_name  = "acr-nwsvcs-prd-secondary-rule-containers"
    backend_http_settings_name = "myHTTPSetting"
    priority                   = 100
  },
  cfprodRoutingRule = {
    name                        = "cfprodRoutingRule"
    rule_type                   = "Basic"
    http_listener_name          = "cfprodlistener"
    redirect_configuration_name = "redirect"
    priority                    = 10
  }
  # Add more rules as needed
}

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

## ------------------------------------
##  ServiceBus Configuration
## ------------------------------------

servicebus_config = {
  name               = "prdaccernservicebus"
  sku                = "Standard"
  local_auth_enabled = false
}

servicebus_queues = {
  BatchQueue = {
    name                                    = "transaction.batch.prod"
    max_delivery_count                      = 10
    enable_batched_operations               = true
    requires_duplicate_detection            = false
    requires_session                        = false
    dead_lettering_on_message_expiration    = false
    enable_partitioning                     = false
    enable_express                          = false
    max_message_size_in_kilobytes           = null
    default_message_ttl                     = "P30D"
    forward_to                              = null
    forward_dead_lettered_messages_to       = null
    auto_delete_on_idle                     = null
    max_size_in_megabytes                   = 1024
    lock_duration                           = "PT5M"
    duplicate_detection_history_time_window = "PT10M"
    status                                  = "Disabled"
  }
}
