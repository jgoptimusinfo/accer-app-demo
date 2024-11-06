# Terraform Customer Network Module

This Terraform module sets up a network infrastructure on Azure, including a virtual network, subnets, route tables, and VPN gateways. It is designed to be flexible and configurable, allowing users to customize various aspects of the network setup.

## Features

* Creates a Virtual Network (VNet)
* Configures subnets within the VNet
* Sets up route tables and routes
* Associates route tables with subnets
* Configures a VPN gateway with optional BGP and active-active settings


## Usage

## Example of Customer Network

```terrafom

module "rg_customer_network" {
  source = "../modules/resource-group"

  location = var.location
  name     = "rg-pdf-cus01-network"
}
 
module "customer_network" {
  source = "../modules/network"

  location            = var.location
  prefix_name         = "pdf-cus01"
  resource_group_name = module.rg_customer_network.name

  address_space = ["10.3.0.0/16"]
  dns_servers   = ["10.3.2.250","168.63.129.16"]

  subnets = {
    backend_snet = {
      name                                          = "backend"
      address_prefixes                              = ["10.3.0.0/24"]
    },
    frontend_snet = {
      name                                          = "frontend"
      address_prefixes                              = ["10.3.1.0/24"]
    },
    domain_controller_snet = {
      name                                          = "ad"
      address_prefixes                              = ["10.3.2.0/24"]
    },
    GatewaySubnet = {
      name                                          = "GatewaySubnet"
      address_prefixes                              = ["10.3.250.0/24"]
    }
  }
}

```

## Example of Customer Network with vpn_gateway enable

```terrafom

module "rg_customer_network" {
  source = "../modules/resource-group"

  location = var.location
  name     = "rg-pdf-cus01-network"
}
 
module "customer_network" {
  source = "../modules/network"

  location            = var.location
  prefix_name         = "pdf-cus01"
  resource_group_name = module.rg_customer_network.name

  address_space = ["10.3.0.0/16"]
  dns_servers   = ["10.3.2.250","168.63.129.16"]

  subnets = {
    backend_snet = {
      name                                          = "backend"
      address_prefixes                              = ["10.3.0.0/24"]
      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = true
      service_endpoints                             = ["Microsoft.Storage"]
      service_endpoint_policy_ids                   = []
      service_delegation_name                       = null
      service_delegation_actions                    = []
    },
    frontend_snet = {
      name                                          = "frontend"
      address_prefixes                              = ["10.3.1.0/24"]
      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = true
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      service_delegation_name                       = null
      service_delegation_actions                    = []
    },
    domain_controller_snet = {
      name                                          = "ad"
      address_prefixes                              = ["10.3.2.0/24"]
      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = true
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      service_delegation_name                       = null
      service_delegation_actions                    = []
    },
    GatewaySubnet = {
      name                                          = "GatewaySubnet"
      address_prefixes                              = ["10.3.250.0/24"]
      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = true
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      service_delegation_name                       = null
      service_delegation_actions                    = []
    }
  }

  routes = {}
  
  enable_vpn_gateway = true
  vpn_gateway_name     = "pdf-cus01-vpngw"
  gateway_type         = "Vpn"
  local_networks = [
    {
      local_gw_name         = "onpremise"
      local_gateway_address = "8.8.8.8"
      local_address_space   = ["10.1.0.0/24"]
      shared_key            = "xpCGkHTBQmDvZK9HnLr7DAvH"
    },
  ]

}

```

## Example of Customer Network with vpn_gateway enable and route tables
```terrafom

module "rg_customer_network" {
  source = "../modules/resource-group"

  location = var.location
  name     = "rg-pdf-cus01-network"
}
 
module "customer_network" {
  source = "../modules/network"

  location            = var.location
  prefix_name         = "pdf-cus01"
  resource_group_name = module.rg_customer_network.name

  address_space = ["10.3.0.0/16"]
  dns_servers   = ["10.3.2.250","168.63.129.16"]

  subnets = {
    backend_snet = {
      name                                          = "backend"
      address_prefixes                              = ["10.3.0.0/24"]
      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = true
      service_endpoints                             = ["Microsoft.Storage"]
      service_endpoint_policy_ids                   = []
      service_delegation_name                       = null
      service_delegation_actions                    = []
    },
    frontend_snet = {
      name                                          = "frontend"
      address_prefixes                              = ["10.3.1.0/24"]
      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = true
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      service_delegation_name                       = null
      service_delegation_actions                    = []
    },
    domain_controller_snet = {
      name                                          = "ad"
      address_prefixes                              = ["10.3.2.0/24"]
      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = true
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      service_delegation_name                       = null
      service_delegation_actions                    = []
    },
    GatewaySubnet = {
      name                                          = "GatewaySubnet"
      address_prefixes                              = ["10.3.250.0/24"]
      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = true
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      service_delegation_name                       = null
      service_delegation_actions                    = []
    }
  }

  routes = {
    default_route = {
      name                   = "default_to_internet"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.0.0.10"
    }
  }
  
  enable_vpn_gateway = false
  vpn_gateway_name     = "pdf-cus01-vpngw"
  gateway_type         = "Vpn"
  local_networks = [
    {
      local_gw_name         = "onpremise"
      local_gateway_address = "8.8.8.8"
      local_address_space   = ["10.1.0.0/24"]
      shared_key            = "xpCGkHTBQmDvZK9HnLr7DAvH"
    },
  ]

}

```
## Input Variables

| Name | Description | Type | Default | Validation |
|------|-------------|------|---------|------------|
| resource_group_name | The name of the resource group in which to create the virtual network. The Resource Group must already exist. | string | n/a | n/a |
| prefix_name | The prefix name of the virtual network. Changing this forces a new resource to be created. | string | n/a | length(var.suffix_name) >= 1 && length(var.prefix_name) <= 80 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$", var.prefix_name)) |
| suffix_name | The suffix name of the virtual network. Changing this forces a new resource to be created. | string | "01" | length(var.suffix_name) >= 1 && length(var.suffix_name) <= 2 && can(regex("^0[1-9]$", var.suffix_name)) |
| location | The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created. | string | n/a | n/a |
| tags | A mapping of tags which should be assigned to Resources. | map(string) | {} | n/a |
| address_space | The address space that is used the virtual network. You can supply more than one address space. | list(string) | n/a | n/a |
| dns_servers | List of IP addresses of DNS servers. | list(string) | [] | n/a |
| log_analytics_workspace_id | Specifies the log analytics workspace id. | string | null | n/a |
| ddos_protection_plan | (Optional) DDos protection enable. | object({ enable = bool, id = string }) | null | n/a |
| routes | Map of spoke routes. | map(object({ name = string, address_prefix = string, next_hop_type = string, next_hop_in_ip_address = optional(string, null) })) | { to_internet = { name = "to_internet", address_prefix = "0.0.0.0/0", next_hop_type = "VirtualAppliance", next_hop_in_ip_address = "10.3.0.250" }, to_security = { name = "to_security", address_prefix = "10.0.0.0/16", next_hop_type = "VnetLocal" } } | n/a |
| subnets | Map of subnets. | map(object({ name = string, address_prefixes = list(string), private_endpoint_network_policies = optional(string, "Disabled"), private_link_service_network_policies_enabled = optional(bool, false), service_endpoints = optional(set(string), []), service_endpoint_policy_ids = optional(list(string), []), service_delegation_name = optional(string, null), service_delegation_actions = optional(list(string), []) })) | { backend_snet = { name = "frontend", address_prefixes = ["10.10.1.0/24"], private_endpoint_network_policies = "Disabled", private_link_service_network_policies_enabled = true, service_endpoints = [], service_endpoint_policy_ids = [], service_delegation_name = null, service_delegation_actions = [] }, frontend_snet = { name = "backend", address_prefixes = ["10.10.2.0/24"], private_endpoint_network_policies = "Disabled", private_link_service_network_policies_enabled = true, service_endpoints = [], service_endpoint_policy_ids = [], service_delegation_name = null, service_delegation_actions = [] }, GatewaySubnet = { name = "GatewaySubnet", address_prefixes = ["10.10.2.0/24"], private_endpoint_network_policies = "Disabled", private_link_service_network_policies_enabled = true, service_endpoints = [], service_endpoint_policy_ids = [], service_delegation_name = null, service_delegation_actions = [] } } | n/a |
| vpn_gateway_name | The name of the Virtual Network Gateway. | string | "" | n/a |
| public_ip_allocation_method | Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Dynamic. | string | "Dynamic" | n/a |
| public_ip_sku | The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic. | string | "Basic" | n/a |
| gateway_type | The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute. | string | "Vpn" | n/a |
| vpn_type | The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased. | string | "RouteBased" | n/a |
| vpn_gw_sku | Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, VpnGw1, VpnGw2, VpnGw3, VpnGw4, VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ, VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments. | string | "VpnGw1" | n/a |
| expressroute_sku | Configuration of the size and capacity of the virtual network gateway for ExpressRoute type. Valid options are Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ and depend on the type, vpn_type and generation arguments. | string | "Standard" | n/a |
| vpn_gw_generation | The Generation of the Virtual Network gateway. Possible values include Generation1, Generation2 or None. | string | "Generation1" | n/a |
| enable_active_active | If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false. | bool | false | n/a |
| enable_bgp | If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false. | bool | false | n/a |
| bgp_asn_number | The Autonomous System Number (ASN) to use as part of the BGP. | string | "65515" | n/a |
| bgp_peering_address_apipa | (Optional) A list of Azure custom APIPA addresses assigned to the BGP peer of the Virtual Network Gateway. | list(string) | [] | n/a |
| bgp_peering_address_ip_configuration_name | (Optional) The name of the IP configuration of this Virtual Network Gateway. In case there are multiple ip_configuration blocks defined, this property is required to specify. | string | "" | n/a |
| bgp_peer_weight | The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100. | string | "" | n/a |
| vpn_client_configuration | Virtual Network Gateway client configuration to accept IPSec point-to-site connections. | object({ address_space = string, certificate = string, vpn_client_protocols = list(string) }) | null | n/a |
| local_networks | List of local virtual network connections to connect to gateway. | list(object({ local_gw_name = string, local_gateway_address = string, local_address_space = list(string), shared_key = string })) | [] | n/a |
| local_bgp_settings | Local Network Gateway's BGP speaker settings. | list(object({ asn_number = number, peering_address = string, peer_weight = number })) | null | n/a |
| gateway_connection_type | The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet). | string | "IPsec" | n/a |
| express_route_circuit_id | The ID of the Express Route Circuit when creating an ExpressRoute connection. | string | null | n/a |
| peer_virtual_network_gateway_id | The ID of the peer virtual network gateway when creating a VNet-to-VNet connection. | string | null | n/a |
| gateway_connection_protocol | The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2. | string | "IKEv2" | n/a |
| local_networks_ipsec_policy | IPSec policy for local networks. Only a single policy can be defined for a connection. | string | null | n/a |
| enable_vpn_gateway | Enable VPN Gateway? | bool | false | n/a |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| azurerm | >= 3.105.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.41.0 |

## Modules

No Modules.