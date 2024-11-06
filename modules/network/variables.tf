## --------------------------------------------------------
## Common variables
## --------------------------------------------------------

variable "resource_group_name" {
  description = "EOT The name of the resource group in which to create the virtual network.The Resource Group must already exist."
  type        = string
}

variable "prefix_name" {
  description = "The prefix name of the virtual network.Changing this forces a new resource to be created."
  type        = string

  validation {
    condition     = length(var.prefix_name) <= 80 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$", var.prefix_name))
    error_message = "Invalid name (check Azure Resource naming restrictions for more info)."
  }
}

variable "suffix_name" {
  description = "The suffix name of the virtual network.Changing this forces a new resource to be created."
  type        = string
  default     = ""

  validation {
    condition     = (length(var.suffix_name) == 0) || (length(var.suffix_name) >= 1 && length(var.suffix_name) <= 2 && can(regex("^0[1-9]$", var.suffix_name)))
    error_message = "Invalid name (check Azure Resource naming restrictions for more info)."
  }
}

variable "location" {
  description = "The Azure Region where the Resource Group should exist.Changing this forces a new Resource Group to be created."
  type        = string
}

variable "tags" {
  description = "A mapping of tags which should be assigned to Resources."
  type        = map(string)
  default     = {}
}

## --------------------------------------------------------
##  virtual network variables
## --------------------------------------------------------

variable "address_space" {
  description = "The address space that is used the virtual network.You can supply more than one address space."
  type        = list(string)
}

variable "dns_servers" {
  description = "List of IP addresses of DNS servers."
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "Specifies the log analytics workspace id"
  type        = string
  default     = null
}

variable "ddos_protection_plan" {
  type = object({
    enable = bool
    id     = string
  })
  description = "(Optional) DDos protection enable"
  default     = null
}

## --------------------------------------------------------
##  Spokes route object definition
## --------------------------------------------------------

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

## --------------------------------------------------------
##  Subnet object definition
## --------------------------------------------------------

variable "subnets" {
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
  default     = {}
  description = <<DESCRIPTION

service_delegation_name
=======================

description:

  The name of service to delegate to. Possible values are GitHub.Network/networkSettings, 
  Microsoft.ApiManagement/service, Microsoft.Apollo/npu, Microsoft.App/environments, 
  Microsoft.App/testClients, Microsoft.AVS/PrivateClouds, Microsoft.AzureCosmosDB/clusters, 
  Microsoft.BareMetal/AzureHostedService, Microsoft.BareMetal/AzureHPC, 
  Microsoft.BareMetal/AzurePaymentHSM, Microsoft.BareMetal/AzureVMware, 
  Microsoft.BareMetal/CrayServers, Microsoft.BareMetal/MonitoringServers, 
  Microsoft.Batch/batchAccounts, Microsoft.CloudTest/hostedpools, Microsoft.CloudTest/images, 
  Microsoft.CloudTest/pools, Microsoft.Codespaces/plans, Microsoft.ContainerInstance/containerGroups, 
  Microsoft.ContainerService/managedClusters, Microsoft.ContainerService/TestClients, 
  Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/servers, 
  Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, 
  Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers,
  Microsoft.DelegatedNetwork/controller, Microsoft.DevCenter/networkConnection, 
  Microsoft.DocumentDB/cassandraClusters, Microsoft.Fidalgo/networkSettings, 
  Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, 
  Microsoft.LabServices/labplans, Microsoft.Logic/integrationServiceEnvironments, 
  Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/dnsResolvers, 
  Microsoft.Network/managedResolvers, Microsoft.Network/fpgaNetworkInterfaces, 
  Microsoft.Network/networkWatchers., Microsoft.Network/virtualNetworkGateways, 
  Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/enterprisePolicies, 
  Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, 
  Microsoft.ServiceNetworking/trafficControllers, Microsoft.Singularity/accounts/networks, 
  Microsoft.Singularity/accounts/npu, Microsoft.Sql/managedInstances, Microsoft.Sql/managedInstancesOnebox, 
  Microsoft.Sql/managedInstancesStage, Microsoft.Sql/managedInstancesTest, Microsoft.Sql/servers, 
  Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, 
  Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments, 
  PaloAltoNetworks.Cloudngfw/firewalls, Qumulo.Storage/fileSystems, and Oracle.Database/networkAttachments.

## --------------------------------------------------------

service_delegation_actions:
===========================

description = 
  The name of service to delegate to. Possible values are 
  Microsoft.Network/networkinterfaces/*, Microsoft.Network/publicIPAddresses/join/action,
  Microsoft.Network/publicIPAddresses/read, Microsoft.Network/virtualNetworks/read, 
  Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, 
  Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action,
  and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.

## --------------------------------------------------------

Service_endpoints:
==================

description = 
  The list of Service endpoints to associate with the subnet. 
  Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry
  Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage,
  Microsoft.Storage.Global and Microsoft.Web.

## --------------------------------------------------------

service_endpoint_policy_ids:
============================

description = 
  The list of Service endpoint policy ids to associate with the subnet. 
  Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry
  Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage,
  Microsoft.Storage.Global and Microsoft.Web.

DESCRIPTION
}


## --------------------------------------------------------
##  VPN Gateway - Variables
## --------------------------------------------------------

variable "vpn_gateway_name" {
  type        = string
  description = "The name of the Virtual Network Gateway"
  default     = ""
}

variable "public_ip_allocation_method" {
  type        = string
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Dynamic"
  default     = "Dynamic"
}

variable "public_ip_sku" {
  type        = string
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic"
  default     = "Basic"
}

variable "gateway_type" {
  type        = string
  description = "The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute"
  default     = "Vpn"
}

variable "vpn_type" {
  type        = string
  description = "The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased"
  default     = "RouteBased"
}

variable "vpn_gw_sku" {
  type        = string
  description = "Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments"
  default     = "VpnGw1"
}

variable "expressroute_sku" {
  type        = string
  description = "Configuration of the size and capacity of the virtual network gateway for ExpressRoute type. Valid options are Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ and depend on the type, vpn_type and generation arguments"
  default     = "Standard"
}

variable "vpn_gw_generation" {
  type        = string
  description = "The Generation of the Virtual Network gateway. Possible values include Generation1, Generation2 or None"
  default     = "Generation1"
}

variable "enable_active_active" {
  type        = bool
  description = "If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false."
  default     = false
}

variable "enable_bgp" {
  type        = bool
  description = "If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false"
  default     = false
}

variable "bgp_asn_number" {
  type        = string
  description = "The Autonomous System Number (ASN) to use as part of the BGP"
  default     = "65515"
}

variable "bgp_peering_address_apipa" {
  type        = list(string)
  description = "(Optional) A list of Azure custom APIPA addresses assigned to the BGP peer of the Virtual Network Gateway."
  default     = []
}

variable "bgp_peering_address_ip_configuration_name" {
  type        = string
  description = "Optional) The name of the IP configuration of this Virtual Network Gateway. In case there are multiple ip_configuration blocks defined, this property is required to specify."
  default     = ""
}

variable "bgp_peer_weight" {
  type        = string
  description = "The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100"
  default     = ""
}

variable "vpn_client_configuration" {
  type        = object({ address_space = string, certificate = string, vpn_client_protocols = list(string) })
  description = "Virtual Network Gateway client configuration to accept IPSec point-to-site connections"
  default     = null
}

variable "local_networks" {
  type        = list(object({ local_gw_name = string, local_gateway_address = string, local_address_space = list(string), shared_key = string }))
  description = "List of local virtual network connections to connect to gateway"
  default     = []
}

variable "local_bgp_settings" {
  type        = list(object({ asn_number = number, peering_address = string, peer_weight = number }))
  description = "Local Network Gateway's BGP speaker settings"
  default     = null
}

variable "gateway_connection_type" {
  type        = string
  description = "The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet)"
  default     = "IPsec"
}

variable "express_route_circuit_id" {
  type        = string
  description = "The ID of the Express Route Circuit when creating an ExpressRoute connection"
  default     = null
}

variable "peer_virtual_network_gateway_id" {
  type        = string
  description = "The ID of the peer virtual network gateway when creating a VNet-to-VNet connection"
  default     = null
}

variable "gateway_connection_protocol" {
  type        = string
  description = "The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2"
  default     = "IKEv2"
}

variable "local_networks_ipsec_policy" {
  type        = string
  description = "IPSec policy for local networks. Only a single policy can be defined for a connection."
  default     = null
}

variable "enable_vpn_gateway" {
  type        = bool
  description = "Enable VPN Gateway ?"
  default     = false
}